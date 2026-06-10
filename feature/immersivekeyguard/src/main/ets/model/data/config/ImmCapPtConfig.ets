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

import { WProperty } from '@ohos/screenlockcommon';
import { PropertyState, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { ImmBasePropertyConfig } from './ImmBasePropertyConfig';
import { ImmCapCfgKey } from './ImmCapCfgKey';

/**
 * 沉浸胶囊属性配置
 */
export class ImmCapPtConfig extends ImmBasePropertyConfig<ImmCapPtConfig> {
  protected getThis(): ImmCapPtConfig {
    return this;
  }

  public bindConfig(key: ImmCapCfgKey, cfg: WidgetPropertyConfig): ImmCapPtConfig {
    return super.bindConfig(key, cfg);
  }

  public getConfig(key: ImmCapCfgKey): WidgetPropertyConfig | undefined {
    return super.getConfig(key);
  }

  public bindPropertySt(key: ImmCapCfgKey, ptSt?: PropertyState): ImmCapPtConfig {
    return super.bindPropertySt(key, ptSt);
  }

  public applyConfig(key?: ImmCapCfgKey, ptArr?: WProperty[]): void {
    super.applyConfig(key, ptArr);
  }

  /**
   * 配置实例
   *
   * param cfgName 配置名称
   * @returns 实例
   */
  public static wrap(cfgName: string): ImmCapPtConfig {
    return new ImmCapPtConfig(cfgName);
  }
}