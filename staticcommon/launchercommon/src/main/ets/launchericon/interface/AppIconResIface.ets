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

import { AppItemInfo } from '../../TsIndex';
import { AppIconData } from '../viewmodel/AppIconData';

export interface AppIconResIface {
  /**
   * 针对外部自定义的Image, 需要覆写该函数, 比如:小文件夹的资源获取方式和桌面图标不一样
   * @param itemInfo AppItemInfo
   */
  initIconImage: (itemInfo: AppItemInfo, iconData: AppIconData) => Promise<void>;

  /**
   * 图标消失场景，重新初始化图标资源
   * @param itemInfo AppItemInfo
   * @param iconData AppIconData
   */
  reInitIconImage?: (itemInfo: AppItemInfo, iconData: AppIconData) => Promise<void>;
}