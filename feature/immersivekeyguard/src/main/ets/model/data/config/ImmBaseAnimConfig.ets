/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, Logger } from '@ohos/basicutils';
import { AnimMgr } from '@ohos/screenlockcommon/Index';
import { ImmersiveTraceHelper } from '../../../common/helper/ImmersiveTraceHelper';
import { ImmBasePropertyConfig } from './ImmBasePropertyConfig';

const TAG = 'ImmBaseAnimConfig';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 动效参数配置
interface InnerAnimateParam {
  animParam: AnimateParam;
  // 标记主动效
  isMainAnim: boolean;
}

// 强制标脏
declare function __updateDirty2Immediately_V2_Change_Observation(): void;

/**
 * 沉浸模块动效配置基类
 */
export abstract class ImmBaseAnimConfig<T extends ImmBasePropertyConfig<T>, S extends ImmBaseAnimConfig<T, S>> {
  // 动效场景
  private animScene: string;

  // 动效初始化配置
  private initCfg?: T;

  // 动效结束配置
  private finishCfg?: T;

  // 动效终值配置集，配合多条动效曲线
  private readonly endCfgArr: T[] = [];

  // 动效曲线参数配置集
  private readonly animParamArr: InnerAnimateParam[] = [];

  protected constructor(scene: string) {
    this.animScene = scene;
  }

  /**
   * 当前实例
   *
   * @returns this
   */
  protected abstract getThis(): S;

  /**
   * 绑定初始化动效配置
   *
   * @param cfg 配置
   * @returns 链式
   */
  public bindInitCfg(cfg: T): S {
    this.initCfg = cfg;
    return this.getThis();
  }

  /**
   * 绑定结束动效配置
   *
   * @param cfg 配置
   * @returns 链式
   */
  public bindFinishCfg(cfg: T): S {
    this.finishCfg = cfg;
    return this.getThis();
  }

  /**
   * 动效终值配置
   *
   * @param cfg 配置
   * @returns 链式
   */
  public addEndCfg(cfg: T): S {
    this.endCfgArr.push(cfg);
    return this.getThis();
  }

  /**
   * 动效曲线配置
   *
   * @param param 动效曲线
   * @param isMainAnim 是否主动效
   * @returns 链式
   */
  public addAnimParam(param: AnimateParam, isMainAnim: boolean = false): S {
    this.animParamArr.push({ animParam: param, isMainAnim: isMainAnim });
    return this.getThis();
  }

  /**
   * 清空动效终值配置，同步清空动效曲线
   */
  public clearEndCfg(): void {
    this.endCfgArr.splice(0);
    this.animParamArr.splice(0);
  }

  /**
   * 取出初始化配置
   *
   * @returns 配置
   */
  public getInitCfg(): T | undefined {
    return this.initCfg;
  }

  /**
   * 取出结束配置
   *
   * @returns 配置
   */
  public getFinishCfg(): T | undefined {
    return this.finishCfg;
  }

  /**
   * 取出动效终值配置
   *
   * @param cfgName 配置名
   * @returns 配置
   */
  public getEndCfg(cfgName: string): T | undefined {
    return this.endCfgArr.find((cfg) => cfg?.getCfgName() === cfgName);
  }

  /**
   * 开启动效执行
   *
   * @param animMgr 动效执行管理器
   */
  public startAnim(animMgr?: AnimMgr): void {
    if (!animMgr) {
      log.showWarn(TAG, `startAnim no anim mgr: ${this.animScene}`);
      return;
    }
    // 开始动效前，应用初始化配置
    this.initCfg?.applyConfig();
    __updateDirty2Immediately_V2_Change_Observation();
    // 动效trace记录
    ImmersiveTraceHelper.startAnimTrace(this.animScene);
    // 顺序触发动效
    this.animParamArr.forEach((param, index) => {
      let endCfg = this.endCfgArr[index];
      // 主动效
      if (param.isMainAnim) {
        this.addMainAnimFinish(param.animParam);
        animMgr.animateTo({ mainScene: this.animScene, oriParam: param.animParam,
          // 动效终值配置应用
          oriEvent: () => {
            endCfg?.applyConfig();
            __updateDirty2Immediately_V2_Change_Observation();
          }});
      } else {
        // 从动效
        animMgr.animateToSecondary({ mainScene: this.animScene, oriParam: param.animParam,
          // 动效终值配置应用
          oriEvent: () => {
            endCfg?.applyConfig();
            __updateDirty2Immediately_V2_Change_Observation();
          }});
      }
    });
  }

  private addMainAnimFinish(param: AnimateParam): void {
    if (!param) {
      return;
    }
    // 主动效结束时处理配置置位
    let oriFinish = param.onFinish;
    param.onFinish = () => {
      // 结束trace记录
      ImmersiveTraceHelper.endAnimTrace(this.animScene);
      // 结束配置应用
      this.finishCfg?.applyConfig();
      this.endCfgArr.forEach((cfg) => cfg?.clearConfig());
      this.initCfg?.clearConfig();
      this.finishCfg?.clearConfig();
      oriFinish?.();
    };
  }
}