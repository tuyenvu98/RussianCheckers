#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
enum PlayerType { human, ai, com };
enum Color { color_b, color_w };
class Player : public QObject
{
    Q_OBJECT
private:
    Color _color;
    PlayerType _type;
public:
    explicit Player(QObject *parent = nullptr,Color c=color_b,PlayerType p=human);
    Color GetColor();
    PlayerType GetType();

};

#endif // PLAYER_H
