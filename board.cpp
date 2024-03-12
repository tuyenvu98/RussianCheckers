#include "board.h"
#include <cstdlib>
#include <QDebug>
#include <QThread>
#include <QtConcurrent>
Board::Board(QObject *parent)
    : QObject{parent}
{
    QVector<QVector<int>> vec(boardSize, QVector<int>(boardSize, 0));
    map=vec;
}

Board::~Board()
{
    delete wPlayer;
    delete bPlayer;
    delete currentPlayer;
}

void Board::init()
{
    QVector<QVector<int>>whitePos,blackPos;
    for ( int i = 0; i < boardSize; i++)
    {
        QVector<int> row;
        for ( int j = 0; j < boardSize; j++)
        {
            if(i==3||i==4||(i+j)%2==0)
            {
                SetCell(j,i,0);
                continue;
            }
            if(i<boardSize/2)
            {
                SetCell(j,i,2);
                whitePos.push_back({j,i});
            }
            else
            {
                SetCell(j,i,1);
                blackPos.push_back({j,i});
            }
        }
        map.push_back(row);
    }
    availablePos[color_b] = blackPos;
    availablePos[color_w] = whitePos;
}

void Board::setUp(Color m_color,PlayerType o_type)
{
    init();
    if(m_color==color_w)
    {
        wPlayer=new Player(this,color_w,human);
        bPlayer = new Player(this,color_b,o_type);
    }
    else
    {
        wPlayer=new Player(this,color_w,o_type);
        bPlayer = new Player(this,color_b,human);
    }
    currentPlayer=wPlayer;
    if(currentPlayer->GetType()==ai)
        AutoMove();
    emit mapChanged();

}


void Board::SetCell(int x, int y, int ct)
{
    map[y][x] = ct;
    if(ct==0)
    {
        availablePos[color_b].removeAll({x,y});
        availablePos[color_w].removeAll({x,y});
        return;
    }
    Color m_color = cellTypeGroup[color_b].contains(ct) ? color_b:color_w;
    availablePos[m_color].push_back({x,y});
}

int Board::GetCell(int x, int y)
{
    return map[y][x];

}

bool Board::checkMove(int startX,int startY, int endX,int endY)
{
    if(endX>=boardSize||endY>=boardSize||endX<0||endY<0)
        return false;
    int startType = GetCell(startX,startY);
    if (!cellTypeGroup[currentPlayer->GetColor()].contains(startType))
        return false;
    if(GetCell(endX,endY)!=0)
        return false;
    bool isQueen= (startType==3||startType==4) ? true:false;
    int dx = endX - startX;
    int dy = endY - startY;
    if(isQueen&& (abs(dx) == abs(dy)))
        return true;
    if (abs(dx) == 1 &&((startType == 1  && dy == -1) || (startType == 2  && dy == 1)))
        return true;
    auto checked = checkedPoints(startX,startY,endX,endY);
    int size=checked.size();
    if ((abs(dx) == 2 &&size==1) && ((startType == 1 && dy == -2 ) || (startType == 2 && dy == 2)))
        return true;
    return false;
}

void Board::makeMove(int startX,int startY, int endX,int endY)
{
    QtConcurrent::run(std::bind(&Board::Move,this,startX,startY,endX,endY));
}

void Board::Move(int startX,int startY, int endX,int endY)
{
    int startType = GetCell(startX,startY);
    auto checked = checkedPoints(startX,startY,endX,endY);
    foreach(auto pos,checked)
    {
        SetCell(pos[0],pos[1], 0);
    }
    SetCell(startX,startY, 0);
    int type = startType;
    if(startType==1&&endY==0)
        type=3;
    if(startType==2&&endY==7)
        type=4;
    SetCell(endX,endY, type);
    if(checked.size()==0)
        currentPlayer= (currentPlayer== wPlayer)? bPlayer:wPlayer;
    emit mapChanged();
    if(Result()>=0)
        return;
    if(currentPlayer->GetType()==com)
    {
        AutoMove();
    }
    if(currentPlayer->GetType()==ai)
    {
        AiMove();
    }
}

void Board::AutoMove()
{
    auto avPos = availablePos[currentPlayer->GetColor()];
    int targetX,targetY,index;
    int count =0;
    while(true)
    {
        int sz= avPos.size();
        if(count>100000)
        {
            foreach(auto e,avPos)
                SetCell(e[0],e[1],0);
            return;
        }
        index = rand() %1000% sz;
        auto startPos= avPos[index];
        int s=2;
        int type= GetCell(startPos[0],startPos[1]);
        if(type==3 ||type==4)
            s=7;
        int d= (rand() % 1000% s)+1;
        int randX= (rand() % 1000 % 2==0) ? -1:1;
        int randY= (rand() % 1000 % 2==0) ? -1:1;
        targetX= startPos[0] +d*randX;
        targetY = startPos[1] +d*randY;
        if(checkMove(startPos[0],startPos[1],targetX,targetY))
        {
            Move(startPos[0],startPos[1],targetX,targetY);
            break;
        }
        count++;
    }
}

void Board::AiMove()
{
    auto curColor =currentPlayer->GetColor();
    auto avPos = availablePos[curColor];
    QVector<int> bestMove;
    int bestWin=-1;
    QList<QThread*> threadList;
    QMutex mutex;
    auto evaluate =[&]() {
        int cur = threadList.indexOf(QThread::currentThread());
        auto startPos= avPos[cur];
        int s=2;
        int type= GetCell(startPos[0],startPos[1]);
        if(type==3 ||type==4)
            s=7;
        for(int m=s*-1;m<=s;m++)
        {
            if(m==0)
                continue;
            for(int n=-1;n<=1;n+=2)
            {
                int targetX= startPos[0] +m;
                int targetY = startPos[1] +m*n;
                if(checkMove(startPos[0],startPos[1],targetX,targetY))
                {
                    int numWin=0;
                    for(int num=0;num<evaluateNum;num++)
                    {
                        QPointer<Board> currentBoard = clone();
                        currentBoard->Move(startPos[0],startPos[1],targetX,targetY);
                        int res=currentBoard->Result();
                        if(res==curColor)
                        {
                            numWin++;
                        }
                    }
                    mutex.lock();
                    if(numWin>bestWin)
                    {
                        bestWin=numWin;
                        bestMove={startPos[0],startPos[1],targetX,targetY};
                    }
                    mutex.unlock();
                }
            }
        }
        QThread::currentThread()->quit();
    };
    for(int i=0;i<avPos.size();i++)
    {
        QThread* workerThread = new QThread;
        QObject::connect(workerThread, &QThread::started, evaluate);
        workerThread->start();
        threadList.append(workerThread);
    }
    for (QThread* thread : threadList) {
        thread->wait();
        delete thread;
    }

    if(bestMove.size()==4)
        Move(bestMove[0],bestMove[1],bestMove[2],bestMove[3]);
    else
        foreach(auto e,avPos)
            SetCell(e[0],e[1],0);

}

QVector<int> Board::state()
{
    QVector<int> res;
    res.push_back(12-availablePos[color_b].size());
    res.push_back(12-availablePos[color_w].size());
    if(currentPlayer->GetColor()==color_b)
        res.push_back(0);
    else
        res.push_back(1);
    if(currentPlayer->GetType()==human)
        res.push_back(0);
    else
        res.push_back(1);
    return res;
}

void Board::setEvaluateNum(int num)
{
    evaluateNum=num;
}

QPointer<Board> Board::clone()
{
    QPointer<Board> cloneBoard(new Board());
    cloneBoard->setMap(map);
    cloneBoard->wPlayer = new Player(cloneBoard,color_w,com);
    cloneBoard->bPlayer = new Player(cloneBoard,color_b,com);
    if(currentPlayer->GetColor()==color_b)
        cloneBoard->currentPlayer=cloneBoard->bPlayer;
    else
        cloneBoard->currentPlayer=cloneBoard->bPlayer;
    cloneBoard->availablePos=availablePos;
    return cloneBoard;
}

QVector<QVector<int>>Board::checkedPoints(int startX,int startY, int endX,int endY)
{
    QVector<QVector<int>> res;
    int dx = endX-startX;
    int dy = endY-startY;
    if(abs(dx)!=abs(dy))
        return res;
    int dimX= (endX>startX) ? 1:-1;
    int dimY= (endY>startY) ? 1:-1;
    for(int i=1;i<abs(dx);i++)
    {
        int tmp = GetCell(startX+i*dimX,startY+i*dimY);
        if(!cellTypeGroup[currentPlayer->GetColor()].contains(tmp)&&tmp!=0)
        {
            res.push_back({startX+i*dimX,startY+i*dimY});
        }
    }
    return res;
}

int Board::Result()
{
    int b = 0,qb=0, w = 0, qw=0;
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            switch (GetCell(i,j)) {
            case 1:
                b++;
                break;
            case 2:
                w++;
                break;
            case 3:
                qb++;
                break;
            case 4:
                qw++;
                break;
            default:
                break;
            }
        }
    }

    if (b+qb == 0)
        return 1;
    else if ( w+qw == 0)
        return 0;
    else if (b == 0 && w == 0 && qb <= 2 && qb == qw)
    {
        return 2;
    }
    return -1;
}

void Board::setMap(QVector<QVector<int>> newMap)
{
    map=newMap;
}


QVector<QVector<int>> Board::getMap()
{
    return map;
}
