/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
 * Information of scene orientation.
 */
export enum SCBSceneOrientation {
  UNSPECIFIED,
  VERTICAL,
  HORIZONTAL,
  REVERSE_VERTICAL,
  REVERSE_HORIZONTAL,
  SENSOR,
  SENSOR_VERTICAL,
  SENSOR_HORIZONTAL,
  AUTO_ROTATION_RESTRICTED,
  AUTO_ROTATION_PORTRAIT_RESTRICTED,
  AUTO_ROTATION_LANDSCAPE_RESTRICTED,
  LOCKED,
  FOLLOW_RECENT,
  AUTO_ROTATION_UNSPECIFIED,
  USER_ROTATION_PORTRAIT,
  USER_ROTATION_LANDSCAPE,
  USER_ROTATION_PORTRAIT_INVERTED,
  USER_ROTATION_LANDSCAPE_INVERTED,
  FOLLOW_DESKTOP,
  USER_PAGE_ROTATION_PORTRAIT = 3000,
  USER_PAGE_ROTATION_LANDSCAPE = 3001,
  USER_PAGE_ROTATION_PORTRAIT_INVERTED = 3002,
  USER_PAGE_ROTATION_LANDSCAPE_INVERTED = 3003,
}
