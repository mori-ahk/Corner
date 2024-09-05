cd ..

source .env

xcodebuild \
  archive \
  -project Corner.xcodeproj/ \
  -scheme Corner \
  -destination 'generic/platform=macOS' \
  -archivePath artifacts/Corner.xcarchive

xcodebuild \
  -exportArchive \
  -archivePath artifacts/Corner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath artifacts/ \
  -allowProvisioningUpdates

create-dmg artifacts/Corner.app artifacts/ --overwrite --dmg-title="Corner" 

mv "$(find artifacts -name 'Corner*.dmg' | head -n 1)" artifacts/Corner.dmg 

xcrun notarytool submit \
  --team-id "$TEAM_ID" \
  --apple-id "$APPLE_ID" \
  --password "$NOTARY_PASSWORD" \
  --wait \
  artifacts/Corner.dmg

xcrun stapler staple artifacts/Corner.dmg
