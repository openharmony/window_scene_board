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
export interface ActivateTheme {
  ID: string,
  ORIGIN: number,
  TYPE: number,
  MESSAGE?: string
}

export interface ActivateDurationErr {
  ID: string,
  ORIGIN: number,
  START_TIME: string,
  DURATION: string,
  RESULT: number
}

export interface InjectThemeSearch {
  LOCALE: string,
  STATUS: number,
  ID: string,
  VERSION: string
}

export interface ApplyTheme {
  PNAMEID: string,
  THEME_TITLE: string,
}