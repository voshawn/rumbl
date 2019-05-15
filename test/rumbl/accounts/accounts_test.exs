defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase
  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      username: "eva",
      credential: %{email: "eva@test", password: "secret"}
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
      assert user.username == "eva"
      assert user.credential.email == "eva@test"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert "has already been taken" in errors_on(changeset).username
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert "should be at most 20 character(s)" in errors_on(changeset).username
      assert Accounts.list_users() == []
    end

    test "requires password to be at least 6 chars long" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["should be at least 6 character(s)"]} == errors_on(changeset).credential
      assert Accounts.list_users() == []
    end
  end
end
