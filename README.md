<h1 align="center">
<a href="https://gamelly.github.io/love-engine"><img width="60%" src="https://raw.githubusercontent.com/gamelly/love-engine/refs/heads/main/assets/banner3.png"></a>
</h1> 

> Reimplementation of the love2d framework to make homebrew games to gba, nds, wii, ps2, tic80 and many other platforms!

## Documentation

 - [Online IDE](https://playground.gamely.com.br)
 - [Building using cmake](https://docs.gamely.com.br/group__native#cmake)
 - [Supporting Love2D from scratch](https://docs.gamely.com.br/group__manual)


### build

```
./cli.sh build samples/pong/main.lua --html
```

## Configuration

* create a `love.json` in in the same folder as the game.

```json
{
    "key_a": "z",
    "key_b": "x",
    "key_c": "c",
    "key_d": "v",
    "key_menu": "p",
    "key_up": "w",
    "key_left": "a",
    "key_down": "s",
    "key_right": "d"
}
```
