/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

export enum SubWindowChangeReason {
  ROTATION,
  FOLD_TO_EXPANDED,
  EXPANDED_TO_FOLD
};

export class LayoutConstants {
  public static readonly BORDER_RESERVE_VP: number = 28;
  public static readonly CENTER_SHAFT_HEIGHT = 48;
  public static readonly BROWSER_BUNDLE_NAME = 'com.ohos.browser';
  public static readonly HT_BROWSER_BUNDLE_NAME = 'com.haitai.htbrowser';
  public static readonly PHOTO_BUNDLE_NAME = 'com.ohos.photos';
}