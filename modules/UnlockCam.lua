-- unlock camera selection:
-- allow Field Side and Live Broadcast cameras, when 2 or more human players are playing on the same team

local m = { version = "1.0" }

--[[
Rewrite this:
00000001414C7C40 | 83FA 07                  | cmp edx,7                                  |
00000001414C7C43 | 73 06                    | jae pes2021.1414C7C4B                      |
00000001414C7C45 | 8991 C8FC0300            | mov dword ptr ds:[rcx+3FCC8],edx           |
00000001414C7C4B | C3                       | ret                                        |
00000001414C7C4C | CC                       | int3                                       |
00000001414C7C4D | CC                       | int3                                       |
00000001414C7C4E | CC                       | int3                                       |

Into this:
00000001414C7C40 | 83FA 07                  | cmp edx,7                                  |
00000001414C7C43 | 73 0A                    | jae pes2021.1414C7C4E                      |
00000001414C7C45 | 80E2 FE                  | and dl,FE                                  | clear lowest bit so that we do not write 1
00000001414C7C48 | 8991 C8FC0300            | mov dword ptr ds:[rcx+3FCC8],edx           |
00000001414C7C4E | C3                       | ret                                        |
--]]

function m.init(ctx)
    local original = "\x83\xfa\x07\x73\x06\x89\x91\xc8\xfc\x03\x00\xc3\xcc\xcc\xcc"
    local patched = "\x83\xfa\x07\x73\x0a\x80\xe2\xfe\x89\x91\xc8\xfc\x03\x00\xc3"
    local addr = memory.search_process(original)
    if addr then
        log(string.format("patched at %s", memory.hex(addr)))
        memory.write(addr, patched)
    else
        error("unable to find code for camera restrictions")
    end
end

return m
