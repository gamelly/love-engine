local os = require('os')

if not arg[1] then
    print('missing game')
    os.exit(1)
end

os.execute('rm -Rf dist')
os.execute('mkdir -p dist')
os.execute('cp src/index.html dist/index.html')
os.execute('cp src/main.lua dist/main.lua')
os.execute('cp '..arg[1]..' dist/game.lua')
