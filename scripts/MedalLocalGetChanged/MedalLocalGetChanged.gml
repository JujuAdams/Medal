function MedalLocalGetChanged()
{
    static _system = __MedalSystem();
    return (_system.__local && _system.__localChanged);
}