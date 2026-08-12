# frozen_string_literal: true

# The fedipub gem only registers :activitypub for the full
# 'application/ld+json; profile="https://www.w3.org/ns/activitystreams"' string.
# Some clients send the bare media type without the profile parameter, so
# accept that as :activitypub too.
# Mime::LOOKUP["application/ld+json"] = Mime[:activitypub]
