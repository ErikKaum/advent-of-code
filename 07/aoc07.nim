import std/enumerate
import strutils
import math
import sequtils

type
    File = ref object
        name: string
        size: int

    Directory = ref object
        name: string
        files: seq[File]
        parent: Directory
        children: seq[Directory]


proc sum_dir(dir: Directory): int =
    var sum = 0
    for file in dir.files:
        sum += file.size

    if dir.children.len() > 0:
        for child in dir.children:
            sum += sum_dir(child)

    result = sum

proc `$`(dir: Directory, depth = 0): string =

    var current_depth = depth
    let tab = repeat("\t", current_depth)
    let sum = sum_dir(dir)

    result = tab & dir.name & " size: " & $sum & "\n" 
    for file in dir.files:
        result = result & tab & file.name & " " & $file.size & "\n"
    
    if dir.children.len() > 0:
        current_depth += 1
        for child in dir.children:
            let from_child = child $ current_depth
            result = result & from_child

proc find_subdir_index(dir: Directory, subdir: string): int =
  
  var found = false
  for i, child in dir.children:
    if child.name == subdir:
      result = i
      found = true
      break
  
  if found == false:
    raise Exception.newException("subdir index not found")

proc get_res(dir: Directory): (seq[int]) =
  var sizes: seq[int]
  let dir_size = sum_dir(dir)
  sizes.add(dir_size)
  
  if dir.children.len() > 0:
    for child in dir.children:
      let sizes_from_subdir = get_res(child)
      sizes.add(sizes_from_subdir)

  result = sizes

type
    Mode = enum
        cd, ls
var mode: Mode

var home = new(Directory)
home.name = "home"
var current_dir = home

let f = open("./input.txt")
for i, line in enumerate(f.lines()):


    if line.contains("$ cd"):
        mode = Mode.cd
    if line.contains("$ ls"):
        mode = Mode.ls

    if (mode == Mode.ls) and (not line.contains("$")):
        let splitted = line.split()

        if splitted[0] == "dir":
            var dir = new(Directory)
            dir.name = splitted[1]
            dir.parent = current_dir
            current_dir.children.add(dir)
        else:
            var file = new(File)
            file.name = splitted[1]
            file.size = parseInt(splitted[0])
            current_dir.files.add(file)

    if (mode == Mode.cd) and (i != 0) and (line != "$ cd .."):
        let splitted = line.split()
        let change_to_this_dir = splitted[2]
        let index = find_subdir_index(currentdir, change_to_this_dir)
        current_dir = current_dir.children[index]


    if line == "$ cd ..":
        current_dir = current_dir.parent

echo home

var res = get_res(home)

# part 1
# var real_res: seq[int]

# for item in res:
#     if item <= 100000:
#         real_res.add(item)

# var sum = 0
# for i in real_res:
#     sum += i

# part 2


let used_space = sum_dir(home)
let total_space = 70000000
let required_space = 30000000
let unused_space = total_space-used_space

let needed_space = required_space - unused_space

var candidates: seq[int]
for item in res:
    if item >= needed_space:
        candidates.add(item)


echo candidates[minIndex(candidates)]


f.close()