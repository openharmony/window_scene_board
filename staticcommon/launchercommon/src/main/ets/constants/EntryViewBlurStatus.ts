/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
 * Common constants for entry view.
 */
export class EntryViewBlurStatus {
  /**
   * default value
   */
  public static readonly DEFAULT = 0;

  /**
   * starting app
   */
  public static readonly START_APP = 1;

  /**
   * closing app
   */
  public static readonly CLOSE_APP = 2;

  /**
   * enter recent
   */
  public static readonly ENTER_RECENT = 3;

  /**
   * exit recent
   */
  public static readonly EXIT_RECENT = 4;

  /**
   * do follow animation
   */
  public static readonly FOLLOW_ANIMATE = 5;

  /**
   * do folder open animation
   */
  public static readonly FOLDER_OPEN = 6;

  /**
   * do folder close animation
   */
  public static readonly FOLDER_CLOSE = 7;

  /**
   * the blur radius of desktop
   */
  public static readonly DESKTOP_BLUR_RADIUS = 60;
}

/**
 * struct of EntryViewBlurStatus
 */
export class EntryViewBlurStatusStruct {
  public status: EntryViewBlurStatus;

  public value: number;

  constructor(status: EntryViewBlurStatus, value: number) {
    this.status = status;
    this.value = value;
  }
}