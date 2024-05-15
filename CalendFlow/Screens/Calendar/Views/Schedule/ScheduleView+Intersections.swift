//
//  ScheduleViewModel.swift
//  CalendFlow
//
//  Created by User on 13.05.2024.
//

import Foundation

struct EventWithIntersections {
    var event: Event
    var intersectionsCount = 0
    var intersectionIndex = 0
}

enum ScheduleViewUtils {
    static func getEventsWithIntersections(events: [Event]) -> [EventWithIntersections] {
        var eventsWithIntersections = events.sorted(by: { $0.startTimeInMinutes < $1.startTimeInMinutes }).map { EventWithIntersections(event: $0) }
        for (index, event) in eventsWithIntersections.enumerated() {
            let intersections = eventsWithIntersections.filter {
                return $0.event.intersects(with: event.event)
            }

            eventsWithIntersections[index].intersectionsCount = intersections.count - 1

            var intersectionStartedBeforeCount = 0

            var selfAlreadyFound = false
            for intersection in intersections {
                if intersection.event.id == event.event.id {
                    selfAlreadyFound = true

                    continue
                }

                if intersection.event.startTimeInMinutes < event.event.startTimeInMinutes {
                    intersectionStartedBeforeCount += 1
                }

                if intersection.event.startTimeInMinutes == event.event.startTimeInMinutes && !selfAlreadyFound {
                    intersectionStartedBeforeCount += 1
                }
            }

            eventsWithIntersections[index].intersectionIndex = intersectionStartedBeforeCount
        }

        return eventsWithIntersections
    }
}
