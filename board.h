#ifndef BOARD_H
#define BOARD_H

#include <QObject>
#include <QDebug>
#include "player.h"
class Board : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVector<QVector<int>> map READ getMap WRITE setMap NOTIFY mapChanged)
private:
    QVector<QVector<int>> map;
    int boardSize=8;
    QMap<Color,QVector<int>> cellTypeGroup= {
        {color_b,{1,3}},
        {color_w,{2,4}}
    };
    Player* currentPlayer;
    Player* wPlayer;
    Player* bPlayer;
    QMap<Color,QVector<QVector<int>>> availablePos;
    int evaluateNum=100;
public:
    explicit Board(QObject *parent = nullptr);
    ~Board();
    QPointer<Board> clone();
    void SetCell(int x,int y, int ct);
    int GetCell(int x,int y);
    QVector<QVector<int>>checkedPoints(int startX,int startY, int endX,int endY);
    void setMap(QVector<QVector<int>> newMap);
    void Move(int startX,int startY, int endX,int endY);
    void AutoMove();
    void AiMove();
    int Result();
    void init();
public slots:
    QVector<int> state();
    void setEvaluateNum(int);
    void makeMove(int startX,int startY, int endX,int endY);
    bool checkMove(int startX,int startY, int endX,int endY);
    void setUp(Color,PlayerType);
    QVector<QVector<int>> getMap();
signals:
    void mapChanged();



};

#endif // BOARD_H
