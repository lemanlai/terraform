locals {
    time_suffix = substr(replace(timestamp(),"/:|-|T|Z",""), 0, 12)
    time_suffix_short = substr(replace(timestamp(),"/:|-|T|Z/",""), 0, 8)
}