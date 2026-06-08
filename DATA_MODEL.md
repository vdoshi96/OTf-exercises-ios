# Data Model

## Source

Exercise data comes from `reference/OTf-exercises/src/data/exercises.json` and is copied into `OTFExercises/Resources/exercises.json`.

Current bundled snapshot:

- 1,231 grouped exercises
- 1,966 video demos
- 7 categories
- 27 muscle groups
- 16 equipment values
- 2 creators
- 2 platforms: Instagram and TikTok

## Core Types

`Exercise`

- `id`
- `exerciseName`
- `category`
- `muscleGroups`
- `equipment`
- `movementType`
- `coachingCues`
- `videos`

`ExerciseVideo`

- `id`
- `url`
- `source`
- `thumbnail`
- `description`
- `creator`

`Creator`

- `id`
- `displayName`
- `handle`
- `profileURL`

## Categories

The iOS enum preserves the source category keys:

- `upper_body`
- `lower_body`
- `core`
- `full_body`
- `cardio`
- `mobility`
- `other`

## Search

The web app uses Fuse.js over exercise names, muscle groups, equipment, creators, creator handles, and coaching cues. The iOS app preserves those fields with a lightweight weighted search:

- exercise name has the highest weight
- muscle groups and equipment are prioritized
- creator name and handle are searchable
- coaching cues are searchable at lower weight
- small token-level typo tolerance is supported

## Filters

The native filter state preserves source filter meaning:

- category
- muscle group
- equipment
- platform
- creators, multi-select
