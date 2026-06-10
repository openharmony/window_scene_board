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

import { CommonConstants } from '../constants/CommonConstants';

const APP_GALLERY_STATUS_CHANGE = 'appGalleryStatusChange';

/**
 * 应用安装事件枚举
 */
export enum AppInstallEventType {
  ICON = 'icon',
  NAME = 'name',
  FOLDER = 'folder',
  SMALL_FOLDER = 'smallFolder',
  UPDATE_NAME = 'updateName',
  UPDATE_ICON = 'updateIcon',
  UPDATE_FOLDER = 'updateFolder',
}

/**
 * 应用安装事件名
 */
export class AppInstallEventKey {
  public static getStatusChangeEventKey(bundleName: string, label: AppInstallEventType): string {
    return `${APP_GALLERY_STATUS_CHANGE}${bundleName}${CommonConstants.MAIN_APP_INDEX}${label}`;
  }
}