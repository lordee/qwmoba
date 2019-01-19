void (entity te) dremove =
{
    if (te == world) {
        dprint("***BUG BUG BUG BUG BUG BUG BUG BUG BUG BUG***\n");
        dprint("WORLD has nearly been removed. Don't worry\n");
        dprint("***BUG BUG BUG BUG BUG BUG BUG BUG BUG BUG***\n");
        return;
    }

    remove(te);
};