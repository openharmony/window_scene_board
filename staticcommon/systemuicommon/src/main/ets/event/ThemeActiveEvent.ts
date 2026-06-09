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
import { CommonEvent } from '@ohos/frameworkwrapper';

/**
 * 主题激活事件
 */
export class ThemeActiveEvent extends CommonEvent {
  public static readonly EVENT_NAME = 'com.ohos.ActivateTheme';
  public static readonly PERMISSION = 'ohos.permission.ACTIVATE_THEME_PACKAGE';
}

Object.defineProperty(ThemeActiveEvent, 'eventTypeName', { value: 'ThemeActiveEvent' });