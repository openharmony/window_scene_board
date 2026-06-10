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

import { WAnimScene } from '@ohos/screenlockcommon';
import { HybridAnimParam } from '../../../../common/constants/ImmComConst';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';

/**
 * 联合动效中的子模块动效配置
 */
export interface IChildHybridAnim {
  /**
   * 联合动效扩展参数
   *
   * @param param 扩展参数
   */
  setHybridAnimParam(param?: HybridAnimParam): void;

  /**
   * 同步alpha动效配置名前缀
   *
   * @param cfgName 配置名
   */
  updateCfgAlphaPrefix?(cfgName: string): void;

  /**
   * 同步点击回弹动效配置名前缀
   *
   * @param cfgName 配置名
   */
  updateCfgClickPrefix?(cfgName: string): void;

  /**
   * 同步main动效配置名前缀
   *
   * @param cfgName 配置名
   */
  updateCfgMainPrefix?(cfgName: string): void;

  /**
   * 子动效初始配置
   *
   * @param initCfg 总配置
   * @param scene 初始化场景
   */
  buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void;

  /**
   * 子动效结束配置
   *
   * @param finishCfg 总配置
   * @param scene 结束场景
   */
  buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void;

  /**
   * 子动效终值配置
   *
   * @param endCfg 总配置
   */
  buildEndCfg(endCfg: ImmComPtConfig): void;

  /**
   * 联合动效启动回调
   *
   * @param animCfg 动效配置
   */
  onHybridAnim(animCfg: ImmComAnimConfig): void;
}