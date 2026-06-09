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
import { ImmAnimParam } from './ImmAnimParam';
import { ImmBasePropertyConfig } from './ImmBasePropertyConfig';
import { ImmCapCfgKey } from './ImmCapCfgKey';
import { ImmCardCfgKey } from './ImmCardCfgKey';
import { ImmListCfgKey } from './ImmListCfgKey';
import { SlClockCfgKey } from './SlClockCfgKey';

// 联合配置类型
type ImmComCfgKey = ImmListCfgKey | ImmCapCfgKey | ImmCardCfgKey | SlClockCfgKey;

/**
 * 沉浸模块联合属性配置
 */
export class ImmComPtConfig extends ImmBasePropertyConfig<ImmComPtConfig> {
  // 动效曲线参数配置
  private animParam?: ImmAnimParam;

  protected getThis(): ImmComPtConfig {
    return this;
  }

  public bindConfig(key: ImmComCfgKey, cfg: WidgetPropertyConfig): ImmComPtConfig {
    return super.bindConfig(key, cfg);
  }

  public getConfig(key: ImmComCfgKey): WidgetPropertyConfig | undefined {
    return super.getConfig(key);
  }

  public bindPropertySt(key: ImmComCfgKey, ptSt?: PropertyState): ImmComPtConfig {
    return super.bindPropertySt(key, ptSt);
  }

  public applyConfig(key?: ImmComCfgKey, ptArr?: WProperty[]): void {
    super.applyConfig(key, ptArr);
  }

  /**
   * 扩展动效曲线绑定
   *
   * @param param 动效曲线配置
   * @returns 链式
   */
  public buildAnimParam(param: ImmAnimParam): ImmComPtConfig {
    this.animParam = param;
    return this;
  }

  /**
   * 动效曲线
   *
   * @returns 动效曲线
   */
  public getAnimParam(): ImmAnimParam | undefined {
    return this.animParam;
  }

  /**
   * 配置实例
   *
   * param cfgName 配置名称
   * @returns 实例
   */
  public static wrap(cfgName: string): ImmComPtConfig {
    return new ImmComPtConfig(cfgName);
  }
}