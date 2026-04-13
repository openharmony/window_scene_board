/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * global search events
 *
 * @since 2023-08-17
 */
export class SearchEvents {
  static readonly EVENT_SEARCH_PACKAGE_ADDED = 'search.event.PACKAGE_ADDED';

  static readonly EVENT_SEARCH_PACKAGE_CHANGED = 'search.event.PACKAGE_CHANGED';

  static readonly EVENT_SEARCH_PACKAGE_REMOVED = 'search.event.PACKAGE_REMOVED';

  static readonly EVENT_SEARCH_PACKAGE_CLICK = 'search.event.PACKAGE_CLICK';

  static readonly EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED = 'search.event.PACKAGE_LANGUAGE_CHANGED';
}