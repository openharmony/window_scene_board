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
import IconInfo from './IconInfo';
import { AppIconIdLoader } from './AppIconIdLoader';
import { IconExtendParam } from './IconExtendParam';


export interface IconCacheFwkInterface {

  /**
   * 从底层获取图标资源
   *
   * @param param 获取图标扩展参数
   * @param bundleName 应用包名
   * @param moduleName  应用模块名
   * @param abilityName 应用名
   * @param size 图标大小
   * @returns 返回icon信息
   */
  getIconResourceFromFwk(param: IconExtendParam, bundleName: string, moduleName?: string, abilityName?: string,
    size?: number): Promise<IconInfo>

  /**
   * 设置appIconIdLoader
   * @param appIconIdLoader
   */
  setAppIconIdLoader(appIconIdLoader: AppIconIdLoader): void;

  /**
   * 刷新maskImage
   */
  refreshMaskImage(): void;
}