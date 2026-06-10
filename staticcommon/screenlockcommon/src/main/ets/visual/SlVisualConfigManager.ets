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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import CommonConstants, { SlAreaType, CcmOption } from '../constants/CommonConstants';

const TAG = 'SlVisualConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export const SL_AREA_ARR = [
  SlAreaType.LOCK_ICON,
  SlAreaType.CLOCK,
  SlAreaType.FORM,
  SlAreaType.NTF_LIST,
  SlAreaType.CAPSULE,
  SlAreaType.IMMERSIVE_CARD
];

/**
 * 锁屏分档视效CCM配置类
 */
export class SlVisualConfigManager {
  private static instance: SlVisualConfigManager;

  /**
   * 表驱动存储参数查询方法
   */
  private getMethodMap: Map<CcmOption, (type?: SlAreaType) => boolean> = new Map();

  /**
   * 关闭整体模糊
   */
  private isAllEffectDisabled: boolean = false;

  /**
   * 区域级模糊开关
   */
  private enableEffectConfig: Map<SlAreaType, boolean> = new Map();

  /**
   * 关闭整体提亮
   */
  private isAllBrightDisabled: boolean = false;

  /**
   * 区域级提亮开关
   */
  private enableBrightConfig: Map<SlAreaType, boolean> = new Map();

  /**
   * 关闭整体纯色
   */
  private isAllSolidDisabled: boolean = true;

  /**
   * 区域级纯色开关
   */
  private enableSolidConfig: Map<SlAreaType, boolean> = new Map();

  /**
   * 默认打开HDR开关
   */
  private isHDRDefaultAble: boolean = false;

  /**
   * 关闭上划进入密码页跟手模糊
   */
  private isBouncerBlurOneFrameCut: boolean = false;

  /**
   * 开启模糊
   *
   * @param slAreaType 组件区域类型
   * @returns true 关闭模糊
   */
  private isEnableEffect = (slAreaType?: SlAreaType): boolean => {
    if (this.isAllEffectDisabled) {
      return false;
    }
    return !this.enableSolid();
  };

  /**
   * 开启提亮
   *
   * @param slAreaType 组件区域类型
   * @returns true 关闭提亮
   */
  private isEnableBright = (slAreaType?: SlAreaType): boolean => {
    if (this.isAllBrightDisabled) {
      return false;
    }
    return !this.enableSolid();
  };

  /**
   * 开启纯色模式
   *
   * @param slAreaType 组件区域类型
   * @returns true 开启纯色模式
   */
  private enableSolid = (slAreaType?: SlAreaType): boolean => {
    if (!this.isAllSolidDisabled) {
      return true;
    }
    if (this.isAllBrightDisabled && slAreaType) {
      return slAreaType === SlAreaType.CAPSULE || slAreaType === SlAreaType.FORM;
    }
    return false;
  };

  private enableHdr = (slAreaType?: SlAreaType): boolean => {
    return this.isHDRDefaultAble;
  }

  /**
   * 构造
   */
  constructor() {
    this.initConfig();
    this.initGetMethod();
  }

  static getInstance(): SlVisualConfigManager {
    if (!SlVisualConfigManager.instance) {
      SlVisualConfigManager.instance = new SlVisualConfigManager();
    }

    return SlVisualConfigManager.instance;
  }

  /**
   * 查词对应区域CCM配置
   *
   * @param option 需要查询的属性
   * @param type 组件所在区域
   * @returns 查询结果
   */
  getEnable(option: CcmOption, type?: SlAreaType): boolean {
    return this.getMethodMap.get(option)?.(type) ?? false;
  }

  /**
   * 从SCB Ccm配置中心查询锁屏配置项并初始化锁屏配置模块
   */
  private initConfig(): void {
    this.isAllEffectDisabled = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.SCREEN_LOCK_EFFECT_DISABLE);
    this.isAllBrightDisabled = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.SCREEN_LOCK_BRIGHT_DISABLE);
    this.isAllSolidDisabled = !SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.SCREEN_LOCK_SOLID_ENABLE);
    this.isHDRDefaultAble = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.SCREEN_LOCK_HDR_ENABLE);
    this.isBouncerBlurOneFrameCut = SCBVisualEffectMgr.isFeatureParamTrue(
      VisualEffectConstants.SCREEN_LOCK_BOUNCER_ONE_FRAME_BLUR);
    SL_AREA_ARR.forEach((areaType: SlAreaType) => {
      this.enableEffectConfig.set(areaType, this.isAllEffectDisabled );
      this.enableBrightConfig.set(areaType, this.isAllBrightDisabled);
      this.enableSolidConfig.set(areaType, this.isAllSolidDisabled);
    });
    log.showInfo(`initConfig effect:${this.isAllEffectDisabled}, bright:${this.isAllBrightDisabled},
      solid:${this.isAllSolidDisabled}`);
  }

  /**
   * 表驱动初始化get方法
   */
  private initGetMethod(): void {
    this.getMethodMap.set(CcmOption.EFFECT, this.isEnableEffect);
    this.getMethodMap.set(CcmOption.BRIGHT, this.isEnableBright);
    this.getMethodMap.set(CcmOption.SOLID, this.enableSolid);
    this.getMethodMap.set(CcmOption.HDR, this.enableHdr);
    this.getMethodMap.set(CcmOption.SLIDE2BOUNCER, (): boolean => { return this.isBouncerBlurOneFrameCut; });
  }
}