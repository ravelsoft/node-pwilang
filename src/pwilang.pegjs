/**
    Pwilang parser definitions.

    @author Christophe Eymard <christophe@ravelsoft.com>
*/
{   
    var current_indent = 0;

    function set_indent (indent) {
        current_indent = indent;
    }

    var tag_stack = [];
    function stack_tag (tag) {
        tag_stack.push ({ tag: tag, indent: current_indent });
    }

    function check_tag_stack () {
        var res = "";
        var top_tag = null;
        while (true) {
            if (!tag_stack.length)
                break;
            top_tag = tag_stack.pop ();
            if (current_indent <= top_tag.indent) {
                // Unstack the topmost tag because we have deindented ; print
                // its closing form : </tag>
                res += top_tag.tag.closing ();
            } else {
                tag_stack.push (top_tag);
                break;
            }
        }
        return res;
    }

    function mod_class (ident) {
        var res = {};
        res[",class"] = [ ident ];
        return res;
    }

    function merge_modifiers (prev, new_one) {
        // New one has priority
        if (new_one[",class"]) {
            prev[",class"] = prev[",class"] || [];
            prev[",class"] = prev[",class"].concat ( new_one[",class"] );
            delete new_one[",class"];
        }
        for (x in new_one) {
            if (new_one.hasOwnProperty (x)) {
                prev[x] = new_one[x];
            }
        }
        return prev;
    }

    function Tag (that) {

        function format_modifiers (mods) {
            var s = "";
            var i = 0;

            for (x in mods) {
                if (mods.hasOwnProperty (x) && x != ",class") {
                    s += " " + x + "=\"" + mods[x] + "\"";
                }
            }

            if (mods[",class"]) {
                s += " class=\"" + mods[",class"].join (" ") + "\"";
                delete mods[",class"];
            }

            return s;
        }

        that.opening = function () {
            return "<" + that.name + format_modifiers (that.mods) + ">";
        }

        that.selfclose = function () {
            return "<" + that.name + format_modifiers (that.mods) + "/>";
        }

        that.closing = function () {
            return "</" + that.name + ">";
        }

        return that;
    }
}

toplevel
    = lines
    / sp:space? { return sp; }

lines
    = line:line lines:lines { return line + lines; }
    / line:line

line
    = end:endline? sp:space? tag:tag contents:anything? { set_indent (sp.length); var res = check_tag_stack () + end + sp + tag.opening () + contents; stack_tag (tag); return res;}
    / end:endline? sp:space? contents:anything { set_indent (sp.length); return check_tag_stack () + end + sp + contents; }
    / end:endline sp:space? { set_indent (0); return check_tag_stack () + end + sp; }

identifier
    = ident:([a-zA-Z_][-:a-zA-Z0-9_]*) { return ident[0] + ident[1].join (""); }

anything
    = any:any anything:anything { return any + anything; }
    / any:any

anything_dquoted
    = any:any !"\"" anything:anything_dquoted { return any + anything; }
    / "\\\""
    / any:any

anything_squoted
    = any:any !"\'" anything:anything_squoted { return any + anything; }
    / "\\'"
    / any:any

anything_inline
    = any:any_inline !"]" anything:anything_inline { return any + anything; }
    / "\\]"
    / any:any_inline

any_inline
    = "\\@"
    / tag_inline
    / tag_to_eol_inline
    / selfclosing_tag
    / !endline character:. { return character; }

any
    = "\\@"
    / tag_inline
    / tag_to_eol
    / selfclosing_tag
    / !endline character:. { return character; }

tag
    = "@" ident:identifier mods:modifiers? space? { return Tag ({ name: ident, mods: mods }); }

tag_to_eol
    = tag:tag anything:anything? { return tag.opening () + anything + tag.closing (); }

tag_to_eol_inline
    = tag:tag anything:anything_inline? { return tag.opening () + anything + tag.closing (); }

tag_inline
    = tag:tag '[' contents:anything_inline ']' { return tag.opening () + contents + tag.closing (); }

selfclosing_tag
    = "@/" ident:identifier mods:modifiers? space? { return Tag ({ name: ident, mods: mods }).selfclose (); }

// Modifiers are Ids, Classes and attributes, in short everything that will end up inside the tag.
modifiers
    = mod:mod modifiers:modifiers { return merge_modifiers (mod, modifiers); }
    / mod

mod
    = space? "\." ident:identifier { return mod_class (ident); }
    / space? "#" ident:identifier { return { id: ident }; }
    / space? ident:identifier "=\"" contents:anything_dquoted "\"" { var r = {}; r[ident] = contents; return r; }
    / space? ident:identifier "=\'" contents:anything_squoted "\'" { var r = {}; r[ident] = contents; return r; }
    / space? ident:identifier ("=\"\""/"=''") { var r = {}; r[ident] = ""; return r; }

space
    = sp:[ \t]+ { return sp.join(""); }

endline
    = end1:"\n" sp:space? end:endline { return end1 + sp + end; }
    / "\n" { return "\n"; }
