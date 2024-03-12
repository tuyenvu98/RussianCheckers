#include "player.h"

Player::Player(QObject *parent, Color c, PlayerType p)
    : QObject{parent}
{
    _color =c;
    _type =p;
}

Color Player::GetColor()
{
    return _color;
}

PlayerType Player::GetType()
{
    return _type;
}
