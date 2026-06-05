@echo off
COPY "Output\AccountServer\Release\AccountServer.exe" "Program\1. Account.exe"
COPY "Output\CacheServer\Release\CacheServer.exe" "Program\6. Cache.exe"
COPY "Output\Certifier\Release\Certifier.exe" "Program\2. Certifier.exe"
COPY "Output\CoreServer\Release\CoreServer.exe" "Program\4. Core.exe"
COPY "Output\DatabaseServer\Release\DatabaseServer.exe" "Program\3. Database.exe"
COPY "Output\LoginServer\Release\LoginServer.exe" "Program\5. Login.exe"
COPY "Output\WorldServer\Release\WorldServer.exe" "Program\7. World.exe"

COPY "Output\Neuz\NoGameguard\Neuz.exe" "Client\Neuz.exe"