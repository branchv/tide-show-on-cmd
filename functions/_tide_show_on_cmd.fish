function _tide_show_on_cmd
    if commandline -P
        return
    end

    if test (count (commandline -poc)) -eq 0
        set -l cmd (commandline -t)
        abbr -q $cmd && set -l var _fish_abbr_$cmd && set cmd $$var # expand abbr

        set -l should_repaint 0
        set -l matches (set -n | string match -r '^tide_show_(.*)_on$')

        for i in (seq 1 2 (count $matches))
            set -l match $matches[$i]
            set -l item $matches[(math $i + 1)]

            if contains -- $cmd $$match
                if not set -q _tide_show_$item
                    set -gx _tide_show_$item 1
                    set should_repaint 1
                end
            else
                if set -q _tide_show_$item
                    set -e _tide_show_$item
                    set should_repaint 1
                end
            end
        end

        if test $should_repaint -eq 1
            commandline -f repaint
        end
    end
end
