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

import { WAnimScene } from '@ohos/screenlockcommon';
import { AnimMgr } from '@ohos/screenlockcommon/Index';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';
import { HybridAnimParam, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmersiveComHelper } from '../../../../common/helper/ImmersiveComHelper';
import { IImmersiveCardAnimVm } from '../../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveNtfVmInjector } from '../../../../common/interface/IImmersiveNtfVmInjector';
import { IImmHybridAnim } from '../../../../common/interface/IImmHybridAnim';
import { ISlClockAnimVm } from '../../../../common/interface/ISlClockAnimVm';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmCardCheckData } from '../../../../model/data/v2/ImmCardCheckData';
import { ImmCardDataArray } from '../../../../model/data/v2/ImmCardDataArray';
import { SlListStaticStateV2 } from '../../../../model/data/v2/SlListStaticStateV2';
import { IChildHybridAnim } from './IChildHybridAnim';

/**
 * 沉浸模块联合动效基类
 */
export abstract class ImmBaseHybridAnim implements IImmHybridAnim {
  // 动效启动场景
  private readonly animStartScene: WAnimScene;

  // 动效结束场景
  private readonly animFinishScene: WAnimScene;

  // 动效分散子模块集
  private childAnimArr?: IChildHybridAnim[];

  // 记录主动效曲线配置
  private mainAnimParam?: ImmAnimParam;

  // 动效配置
  protected readonly animCfg: ImmComAnimConfig;

  // 注入器
  protected readonly vmInjector: IImmersiveNtfVmInjector;

  // 动效中扩展参数
  protected extendAnimParam?: HybridAnimParam;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
    let animScene = this.getAnimScene();
    this.animStartScene = { animScene: animScene, isAnimating: true };
    this.animFinishScene = { animScene: animScene, isAnimating: false };
    this.animCfg = ImmComAnimConfig.wrap(animScene);
    this.initCfg();
  }

  /**
   * 动效场景
   *
   * @returns 场景标识
   */
  public abstract getAnimScene(): ImmComAnimScene;

  /**
   * 扩展参数
   *
   * @param param 扩展参数
   */
  public setHybridAnimParam(param?: HybridAnimParam): void {
    this.extendAnimParam = param;
    // 参数透传子模块
    this.getChildAnimArr()?.forEach((child) => child?.setHybridAnimParam(param));
  }

  /**
   * 动效触发
   */
  public onHybridAnim(): void {
    // 子模块感知动效启动
    this.getChildAnimArr()?.forEach((child) => child?.onHybridAnim(this.animCfg));
    // 开启动效前，主动效结束回调中加入扩展回调
    this.mainAnimParam?.addDynamicFinish(this.extendAnimParam?.onFinish);
    // 开启动效
    this.animCfg?.startAnim(this.getAnimMgr());
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
  }

  /**
   * 初始化动效配置
   */
  protected initCfg(): void {
    // 提前同步end动效前缀
    this.getChildAnimArr()?.forEach((child) => {
      child?.updateCfgAlphaPrefix?.(this.getCfgAlphaPrefix());
      child?.updateCfgClickPrefix?.(this.getCfgClickPrefix());
      child?.updateCfgMainPrefix?.(this.getCfgMainPrefix());
    });
  }

  /**
   * 动效分散到子模块，子模块集
   *
   * @returns 子模块集
   */
  protected abstract createChildAnim(): IChildHybridAnim[];

  /**
   * 动效启动前初始化配置
   *
   * @param initCfg 总配置
   */
  protected buildInitCfg(initCfg: ImmComPtConfig): void {
    this.getChildAnimArr()?.forEach((child) => child?.buildInitCfg(initCfg, this.getAnimStartScene()));
    this.animCfg.bindInitCfg(initCfg);
  }

  /**
   * 动效结束后配置
   *
   * @param finishCfg 总配置
   */
  protected buildFinishCfg(finishCfg: ImmComPtConfig): void {
    this.getChildAnimArr()?.forEach((child) => child?.buildFinishCfg(finishCfg, this.getAnimFinishScene()));
    this.animCfg.bindFinishCfg(finishCfg);
  }

  /**
   * 添加动效终值配置
   *
   * @param endCfg 总配置
   */
  protected addEndCfg(endCfg: ImmComPtConfig): void {
    this.getChildAnimArr()?.forEach((child) => child?.buildEndCfg(endCfg));
    this.animCfg.addEndCfg(endCfg);
    // 同步绑定动效曲线
    let animParam = endCfg?.getAnimParam();
    if (animParam) {
      let animateParam = animParam.getAnimParam();
      let isMainAnim = animParam.isMainAnim();
      this.animCfg.addAnimParam(animateParam, isMainAnim);
      // 记录主动效曲线
      if (isMainAnim) {
        this.mainAnimParam = animParam;
      }
    }
  }

  /**
   * 开启播控同步动效
   */
  protected startMediaAnim(): void {
    ImmersiveComHelper.startMediaAnim(this.getAnimScene());
  }

  /**
   * alpha动效配置前缀
   *
   * @returns 前缀
   */
  protected getCfgAlphaPrefix(): string {
    return '';
  }

  /**
   * click回弹动效配置前缀
   *
   * @returns 前缀
   */
  protected getCfgClickPrefix(): string {
    return '';
  }

  /**
   * main动效配置前缀
   *
   * @returns 前缀
   */
  protected getCfgMainPrefix(): string {
    return '';
  }

  /**
   * alpha动效名
   *
   * @param index 索引
   * @returns 动效名
   */
  protected getCfgAlphaName(index: number): string {
    return `${this.getCfgAlphaPrefix()}_${index}`;
  }

  /**
   * Main动效名
   *
   * @param index 索引
   * @returns 动效名
   */
  protected getCfgMainName(index: number): string {
    return `${this.getCfgMainPrefix()}_${index}`;
  }

  /**
   * 列表模块静态状态
   *
   * @returns 状态
   */
  protected getListStaticSt(): SlListStaticStateV2 | undefined {
    return this.vmInjector?.getImmersiveListVm()?.getSlStaticState();
  }

  /**
   * 列表模块数据列表
   *
   * @returns 数据列表
   */
  protected getListData(): NotificationArray | undefined {
    return this.vmInjector?.getImmersiveListVm()?.getSlNtfList();
  }

  /**
   * 动效执行器
   *
   * @returns 动效执行器
   */
  protected getAnimMgr(): AnimMgr | undefined {
    return this.vmInjector?.getImmersiveWholeAnimVm()?.getAnimExeMgr();
  }

  /**
   * 沉浸大卡模块动效管理器
   *
   * @returns 动效管理器
   */
  protected getCardAnimVm(): IImmersiveCardAnimVm {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  /**
   * 时钟动效管理器
   *
   * @returns 动效管理器
   */
  protected getClockAnimVm(): ISlClockAnimVm {
    return this.vmInjector?.getSlClockAnimVm();
  }

  /**
   * 沉浸大卡数据集
   *
   * @returns 大卡数据集
   */
  protected getCardData(): ImmCardDataArray | undefined {
    return this.vmInjector?.getImmersiveCardVm()?.getSlCardData();
  }

  /**
   * 沉浸大卡检测数据集
   *
   * @returns 大卡数据集
   */
  protected getCardCheckData(): ImmCardCheckData | undefined {
    return this.vmInjector?.getImmersiveCardVm()?.getCheckCardData();
  }

  /**
   * 动效启动场景
   *
   * @returns 动效场景
   */
  protected getAnimStartScene(): WAnimScene {
    return this.animStartScene;
  }

  /**
   * 动效结束场景
   *
   * @returns 动效场景
   */
  protected getAnimFinishScene(): WAnimScene {
    return this.animFinishScene;
  }

  private getChildAnimArr(): IChildHybridAnim[] {
    if (!this.childAnimArr) {
      this.childAnimArr = this.createChildAnim();
    }
    return this.childAnimArr;
  }
}