-- ----------------------------------------------------------------------------
-- AddOn Namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName = ... ---@type string
local private = select(2, ...) ---@class PrivateNamespace

---@class BlizzConfigDialogTest: AceAddon, AceConsole-3.0, AceEvent-3.0
BlizzConfigDialogTest = LibStub("AceAddon-3.0"):NewAddon(AddOnFolderName, "AceConsole-3.0", "AceEvent-3.0")

-- ----------------------------------------------------------------------------
-- Preferences
-- ----------------------------------------------------------------------------
local metaVersion = C_AddOns.GetAddOnMetadata(AddOnFolderName, "Version")
local isDevelopmentVersion = metaVersion == "@project-version@"

local buildVersion = isDevelopmentVersion and "Development Version" or metaVersion

---@type table
local Options

---@type table
local defaultValues = {
    TestToggle = false,
    TestRange = 5,

    TestSubToggle = false,
    TestSubRange = 5,
}

---@class Preferences
---@field OptionsFrame Frame
---@field SettingsPanel Frame
local Preferences = {
    DisabledIntegrations = {},
    DefaultValues = {
        profile = defaultValues,
    },
    GetOptions = function()
        if not Options then
            local DB = private.DB.profile

            local count = 1
            local function increment() count = count + 1; return count end;

            Options = {
                type = "group",
                name = ("%s - %s"):format(AddOnFolderName, buildVersion),
                childGroups = "tab",
                args = {
                    general = {
                        order = increment(),
                        type = "group",
                        name = "General",
                        args = {
                            testHeader = {
                                order = increment(),
                                type = "header",
                                name = "Test Header",
                            },

                            testExecute = {
                                order = increment(),
                                type = "execute",
                                name = "Test Execute",
                                func = function()
                                    DevTools_Dump("ere")
                                end
                            },

                            testToggle = {
                                order = increment(),
                                type = "toggle",
                                name = "Test Toggle",
                                desc = "This is just a test",
                                width = "double",
                                get = function()
                                    return DB.TestToggle
                                end,
                                set = function(_, value)
                                    DB.TestToggle = value
                                end,
                                defaultValue = defaultValues.TestToggle
                            },

                            testKeybind = {
                                type = "keybinding",
                                action = "ASSISTTARGET",
                                order = increment(),
                            },

                            testRange = {
                                type = "range",
                                name = "Test Range",
                                desc = "This is just a test",
                                min = 1,
                                max = 20,
                                step = 1,
                                set = function(_, value) DB.TestRange = value end,
                                get = function() return DB.TestRange end,
                                order = increment(),
                                width = "double",
                                defaultValue = defaultValues.TestRange
                            },

                            testSubCategory = {
                                order = increment(),
                                type = "group",
                                name = "Test Sub Category",

                                args = {
                                    testSubHeader = {
                                        order = increment(),
                                        type = "header",
                                        name = "Test Sub Header",
                                    },

                                    testSubExecute = {
                                        order = increment(),
                                        type = "execute",
                                        name = "Test Sub Execute",
                                        func = function()
                                            DevTools_Dump("ere")
                                        end
                                    },

                                    testSubToggle = {
                                        order = increment(),
                                        type = "toggle",
                                        name = "Test Sub Toggle",
                                        desc = "This is just a test",
                                        width = "double",
                                        get = function()
                                            return DB.TestSubToggle
                                        end,
                                        set = function(_, value)
                                            DB.TestSubToggle = value
                                        end,
                                        defaultValue = defaultValues.TestSubToggle
                                    },

                                    testSubKeybind = {
                                        type = "keybinding",
                                        action = "ASSISTTARGET",
                                        order = increment(),
                                    },

                                    testSubRange = {
                                        type = "range",
                                        name = "Test Sub Range",
                                        desc = "This is just a test",
                                        min = 1,
                                        max = 20,
                                        step = 1,
                                        set = function(_, value) DB.TestSubRange = value end,
                                        get = function() return DB.TestSubRange end,
                                        order = increment(),
                                        width = "double",
                                        defaultValue = defaultValues.TestSubRange
                                    },
                                }
                            }
                        }
                    }
                },
            }

            -- Get the option table for profiles
	        --Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(private.DB)
        end

        return Options
    end,
    ---@param self Preferences
    InitializeDatabase = function(self)
        return LibStub("AceDB-3.0"):New(AddOnFolderName .. "DB", self.DefaultValues, true)
    end,
    ---@param self Preferences
    SetupOptions = function(self)
        LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(AddOnFolderName, self.GetOptions, true)
        self.OptionsFrame = LibStub("BlizzConfigDialog-1.0"):AddToBlizOptions(AddOnFolderName)
    end,
}

private.Preferences = Preferences

-- Core initialisation
function BlizzConfigDialogTest:OnInitialize()
    local DB = private.Preferences:InitializeDatabase()

    private.DB = DB

    private.Preferences:SetupOptions()
end
