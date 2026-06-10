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

export interface ThemeAppStatusService {
  /**
   * 注册主题app卸载事件监听
   */
  registerUninstallSubscriber(): void;

  /**
   * 获取应用安装状态
   *
   * @param bundleName 应用报名
   * @returns true表示已安装，false表示未安装
   */
  getBundleStatus(bundleName: string): Promise<boolean>;
}
