
# Synlog
*A debug display for Synapse X*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
synlog = NEON:github('belkworks', 'synlog')
```

***Note***: This documentation is **UNFINISHED**!  
Some functions may not be documented.  

## API

**print**: `synlog:print(...blocks) -> nil`  
Print all of `blocks` separated with a space.
```lua
synlog:print('hello', 'world', 123) -- prints 'hello world 123'
```

**error, warning, info & success**: `synlog:[method](...blocks) -> nil`  
Same as **print**, but prefixes the blocks with a colored tag.
```lua
synlog:error('something happened') -- prints 'ERROR something happened'
```

### Preview
![a picture of synlog](https://i.imgur.com/Il3gYUq.png)
### Using with [logfile](https://github.com/Belkworks/logfile)

Call the `:logger()` method to get a logfile-compatible writer.
```lua
file = log.logfile('events.log')
levels = {
    system = "WARN",
    other = "INFO",
    hush = "OFF"
}

combined = log.combine(file, synlog:logger())
log.init(levels, combined)
```

### Using Colors

To create a colored block of text, synlog provides a **chalk** function.  
You can mix and match as many color blocks as you want.
```lua
chalk = synlog.chalk
synlog:print('hello', chalk('world').light.red) -- prints 'hello world'
-- 'world' will be light red (light is a modifier)
```
![enter image description here](https://i.imgur.com/eo6Bo9r.png)

A list of colors can be found in the source code.
