
-- вот это
Account = {balance = 0}
function Account.withdraw (v)
    Account.balance = Account.balance - v
end

-- просто синтаксический сахар для

Account = {
    balance = 0,
    withdraw = function (v)
        Account.balance = Account.balance - v
    end
}