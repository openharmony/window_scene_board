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

@Observed
export class RunningAppListState {
  public icon: string | Resource; // 应用图标
  public appName: string; // 应用名称
  public subName?: string; // 应用详细名称（暂不支持）
  public hasDivider: boolean; // 是否需要显示分割线（只有列表最后一项不显示）

  constructor() {
    this.icon = '';
    this.appName = '';
    this.hasDivider = true;
  }
}

@Observed
export class RunningAppListStateArray extends Array<RunningAppListState> {
}

export interface TempAppInfo {
  name: string;
  description: string;
  label: string;
  iconResource: Resource;
  labelResource: Resource;
  descriptionResource: Resource;
  systemApp: boolean;
}