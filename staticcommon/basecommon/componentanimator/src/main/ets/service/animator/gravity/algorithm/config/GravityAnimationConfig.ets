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


import curves from '@ohos.curves';
import { util } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {viewMgrPolicy, ViewCallback, ViewType } from '@ohos/frameworkwrapper';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'GravityAnimationConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 引力动效配置类
 * 配置入口：
 * 1. rawfile的gravity_animation_parameter.json，支持产品化配置
 * 2. 通过DEBUG接口的配置
 * 3. 默认配置
 *
 * @since 2024/04/20
 */
export class GravityAnimationConfig {
  private static readonly CONFIG_PATH = 'gravity_animation_parameter.json'
  private static readonly DISABLE = 0;
  private static readonly MAX_RADIUS = 500;
  private static readonly MAX_RADIUS_FACTOR = 0;
  private static readonly MIN_RADIUS = 0;
  private static readonly WAVE_SPEED = 200;
  private static readonly WAVE_AMPLITUDE_CONSTANT = 20;
  private static readonly WAVE_DURATION = 500;
  private static readonly CURVE = 'Linear';
  private static readonly CURVE_PARAMETER1 = 0;
  private static readonly CURVE_PARAMETER2 = 0;
  private static readonly CURVE_PARAMETER3 = 0;
  private static readonly CURVE_PARAMETER4 = 0;
  private static readonly DELAY_ON_DROP = 200;
  private static readonly DELAY_ON_FOLDER_CHANGE_TO_BIG = 200;
  private static readonly DELAY_ON_FOLDER_CHANGE_TO_SMALL = 200;
  private static readonly DELAY_ON_REMOVE_APPLICATION = 200;
  private static readonly DELAY_ON_REMOVE_CARD = 200;
  private static readonly DELAY_ON_ADD_CARD = 200;
  private static readonly DELAY_ON_MERGE_AS_FOLDER = 200;
  private static readonly DELAY_ON_ADD_TO_FOLDER = 200;

  /* 引力动效开启关闭状态 */
  private static enable: number = GravityAnimationConfig.DISABLE;
  /* 引力动效最大范围半径，单位PX */
  private static maxRadius: number = GravityAnimationConfig.MAX_RADIUS;
  /* 引力动效最大范围半径放大系数 */
  private static maxRadiusFactor: number = GravityAnimationConfig.MAX_RADIUS_FACTOR;
  /* 引力动效最小范围半径，单位PX */
  private static minRadius: number = GravityAnimationConfig.MIN_RADIUS;
  /* 引力波传播速率，单位PX/s */
  private static waveSpeed: number = GravityAnimationConfig.WAVE_SPEED;
  /* 控件做引力动效时波动范围的常量 */
  private static waveAmplitudeConstant: number = GravityAnimationConfig.WAVE_AMPLITUDE_CONSTANT;
  /* 控件做引力动效时单向动效时长，单位ms */
  private static waveDuration: number = GravityAnimationConfig.WAVE_DURATION;
  /* 动效曲线 */
  private static curve: string = GravityAnimationConfig.CURVE;
  /* 动效曲线参数1 */
  private static curveParam1: number = GravityAnimationConfig.CURVE_PARAMETER1;
  /* 动效曲线参数2 */
  private static curveParam2: number = GravityAnimationConfig.CURVE_PARAMETER2;
  /* 动效曲线参数3 */
  private static curveParam3: number = GravityAnimationConfig.CURVE_PARAMETER3;
  /* 动效曲线参数4 */
  private static curveParam4: number = GravityAnimationConfig.CURVE_PARAMETER4;
  /* 拖拽场景下的引力动效延迟时间 */
  private static delayOnDrop: number = GravityAnimationConfig.DELAY_ON_DROP;
  /* 拖拽场景下的引力动效延迟时间 */
  private static delayOnFolderChangeToBig: number = GravityAnimationConfig.DELAY_ON_FOLDER_CHANGE_TO_BIG;
  /* 拖拽场景下的引力动效延迟时间 */
  private static delayOnFolderChangeToSmall: number = GravityAnimationConfig.DELAY_ON_FOLDER_CHANGE_TO_SMALL;
  /* 删除应用/快捷方式场景下的引力动效延迟时间 */
  private static delayOnRemoveApplication: number = GravityAnimationConfig.DELAY_ON_REMOVE_APPLICATION;
  /* 删除卡片场景下的引力动效延迟时间 */
  private static delayOnRemoveCard: number = GravityAnimationConfig.DELAY_ON_REMOVE_CARD;
  /* 删除卡片场景下的引力动效延迟时间 */
  private static delayOnAddCard: number = GravityAnimationConfig.DELAY_ON_ADD_CARD;
  /* 拖拽图标合并成文件夹场景引力动效延迟时间 */
  private static delayOnMergeAsFolder: number = GravityAnimationConfig.DELAY_ON_MERGE_AS_FOLDER;
  /* 拖拽图标合落入文件夹场景引力动效延迟时间 */
  private static delayOnAddToFolder: number = GravityAnimationConfig.DELAY_ON_ADD_TO_FOLDER;
  /* 是否初始化过配置 */
  private static initialed: boolean = false;
  /* 曲线map */
  private static curveMap: Map<string, Curve | ICurve> = new Map<string, Curve | ICurve>();

  private static initialCurve(): void {
    GravityAnimationConfig.curveMap.set(GravityAnimationConfig.CURVE, Curve.Linear);
    GravityAnimationConfig.curveMap.set('Ease', Curve.Ease);
    GravityAnimationConfig.curveMap.set('EaseIn', Curve.EaseIn);
    GravityAnimationConfig.curveMap.set('EaseOut', Curve.EaseOut);
    GravityAnimationConfig.curveMap.set('EaseInOut', Curve.EaseInOut);
    GravityAnimationConfig.curveMap.set('FastOutSlowIn', Curve.FastOutSlowIn);
    GravityAnimationConfig.curveMap.set('LinearOutSlowIn', Curve.LinearOutSlowIn);
    GravityAnimationConfig.curveMap.set('FastOutLinearIn', Curve.FastOutLinearIn);
    GravityAnimationConfig.curveMap.set('ExtremeDeceleration', Curve.ExtremeDeceleration);
    GravityAnimationConfig.curveMap.set('Sharp', Curve.Sharp);
    GravityAnimationConfig.curveMap.set('Rhythm', Curve.Rhythm);
    GravityAnimationConfig.curveMap.set('Smooth', Curve.Smooth);
    GravityAnimationConfig.curveMap.set('Friction', Curve.Friction);
    GravityAnimationConfig.curveMap.set('CubicBezierCurve', curves.cubicBezierCurve(GravityAnimationConfig.curveParam1,
      GravityAnimationConfig.curveParam2, GravityAnimationConfig.curveParam3, GravityAnimationConfig.curveParam4));
    GravityAnimationConfig.curveMap.set('SpringCurve', curves.springCurve(GravityAnimationConfig.curveParam1,
      GravityAnimationConfig.curveParam2, GravityAnimationConfig.curveParam3, GravityAnimationConfig.curveParam4));
    GravityAnimationConfig.curveMap.set('SpringMotionCurve', curves.springMotion(GravityAnimationConfig.curveParam1,
      GravityAnimationConfig.curveParam2, GravityAnimationConfig.curveParam3));
    GravityAnimationConfig.curveMap.set('ResponsiveSpringMotionCurve',
      curves.responsiveSpringMotion(GravityAnimationConfig.curveParam1,
        GravityAnimationConfig.curveParam2, GravityAnimationConfig.curveParam3));
    GravityAnimationConfig.curveMap.set('InterpolatingSpring',
      curves.interpolatingSpring(GravityAnimationConfig.curveParam1,
        GravityAnimationConfig.curveParam2, GravityAnimationConfig.curveParam3, GravityAnimationConfig.curveParam4));
  }

  private static loadProfile(configPath?: string): object | null {
    try {
      log.showInfo('start to load %{public}s from rawfile', DeviceHelper.DEVICE_TYPE);
      const path: string = configPath ? configPath : GravityAnimationConfig.CONFIG_PATH;
      let raw = GlobalContext.getContext().resourceManager.getRawFileContentSync(path);
      let decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      let str = decoder.decodeWithStream(raw, { stream: false });
      let total: object[] = JSON.parse(str);
      for (let item of total) {
        if (item['type'] === DeviceHelper.getDeviceType()) {
          return item['parameters'];
        }
      }
    } catch (error) {
      log.showError(`load config file failed, code: ${error.code}, message: ${error.message}.`);
    }
    return null;
  }

  private static loadNumberData(json: object | null, name: string, dft: number): number {
    try {
      if (json && json[name] && typeof json[name] === 'number') {
        log.showDebug(`number paremeter %{public}s is set as:  %{public}d`, name, dft);
        return json[name] as number;
      }
      log.showWarn(`number paremeter %{public}s is invalid: %{public}s, using default %{public}d`,
        name, typeof json?.[name], dft);
    } catch (error) {
      log.showWarn(`number paremeter %{public}s setting failed %{public}d:%{public}s, using default %{public}d`,
        name, error.code, error.message, dft);
    }
    return dft;
  }

  private static loadStringData(json: object | null, name: string, dft: string): string {
    try {
      if (json && json[name] && typeof json[name] === 'string') {
        log.showDebug(`string paremeter %{public}s is set as: %{public}s`, name, dft);
        return json[name];
      }
      log.showWarn(`string paremeter %{public}s is invalid: %{public}s, using default %{public}s`,
        name, typeof json?.[name], dft);
    } catch (error) {
      log.showWarn(`string paremeter %{public}s setting failed %{public}d:%{public}s, using default %{public}s`,
        name, error.code, error.message, dft);
    }
    return dft;
  }

  /**
   * 加载配置，只加载首次
   */
  public static initial(): void {
    if (!GravityAnimationConfig.initialed) {
      GravityAnimationConfig.reset();
      GravityAnimationConfig.initialCurve();
      GravityAnimationConfig.initialed = true;
    }
  }

  /**
   * 设置引力动效是否开启
   *
   * @param enable 是否开启（整体全场景）
   */
  public static setEnable(enable: number): void {
    log.showInfo('ENABLE parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.enable, enable);
    GravityAnimationConfig.enable = enable;
  }

  /**
   * 设置引力范围上限，距离引力点大于这个范围的元素不受引力影响
   *
   * @param enable 引力范围上限R
   */
  public static setMaxRadius(maxRadius: number): void {
    log.showInfo('MAX-RADIUS parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.maxRadius, maxRadius);
    GravityAnimationConfig.maxRadius = maxRadius;
  }

  /**
   * 设置引力范围上限放大系数，用于解决大卡片、大文件夹触发的引力动效，和小图标效果一致问题
   *
   * @param enable 引力范围上限放大系数
   */
  public static setMaxRadiusFactor(maxRadiusFactor: number): void {
    log.showInfo('MAX-RADIUS-FACTOR parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.maxRadius, maxRadiusFactor);
    GravityAnimationConfig.maxRadiusFactor = maxRadiusFactor;
  }

  /**
   * 设置引力范围下限，距离引力点不大于这个范围的元素不受引力影响
   *
   * @param enable 引力范围下限
   */
  public static setMinRadius(minRadius: number): void {
    log.showInfo('MIN-RADIUS parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.minRadius, minRadius);
    GravityAnimationConfig.minRadius = minRadius;
  }

  /**
   * 设置引力传播速度s，用以计算引力动画延时
   *
   * @param enable 引力传播速度
   */
  public static setWaveSpeed(waveSpeed: number): void {
    log.showInfo('WAVE-SPEED parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.waveSpeed, waveSpeed);
    GravityAnimationConfig.waveSpeed = waveSpeed;
  }

  /**
   * 设置引力系数G，用物理模型计算运动曲线
   *
   * @param enable 引力传播速度
   */
  public static setWaveRangeConstant(waveRangeConstant: number): void {
    log.showInfo('WAVE-RANGE-CONSTANT parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.waveAmplitudeConstant, waveRangeConstant);
    GravityAnimationConfig.waveAmplitudeConstant = waveRangeConstant;
  }

  /**
   * 设置物理模型计算运动曲线持续时间
   *
   * @param enable 物理模型计算运动曲线持续时间
   */
  public static setWaveDuration(waveDuration: number): void {
    log.showInfo('WAVE-DURATION parameter change from %{public}d to %{public}d',
      GravityAnimationConfig.waveDuration, waveDuration);
    GravityAnimationConfig.waveDuration = waveDuration;
  }

  /**
   * 设置物理模型计算运动曲线，支持预置曲线和通用曲线
   *
   * @param enable 物理模型计算运动曲线
   */
  public static setCurve(curve: string): void {
    log.showInfo('CURVE change from %{public}s to %{public}s',
      GravityAnimationConfig.curve, curve);
    GravityAnimationConfig.curve = curve;
  }

  /**
   * 设置物理模型计算运动曲线参数1
   *
   * @param enable 物理模型计算运动曲线参数1
   */
  public static setCurveParam1(curveParam: number): void {
    log.showInfo('CURVE-PARAMETER-1 change from %{public}d to %{public}d',
      GravityAnimationConfig.curveParam1, curveParam);
    GravityAnimationConfig.curveParam1 = curveParam;
    /* 需要重新设置曲线，使参数生效 */
    GravityAnimationConfig.initialCurve();
  }

  /**
   * 设置物理模型计算运动曲线参数2
   *
   * @param enable 物理模型计算运动曲线参数2
   */
  public static setCurveParam2(curveParam: number): void {
    log.showInfo('CURVE-PARAMETER-2 change from %{public}d to %{public}d',
      GravityAnimationConfig.curveParam2, curveParam);
    GravityAnimationConfig.curveParam2 = curveParam;
    GravityAnimationConfig.initialCurve();
  }

  /**
   * 设置物理模型计算运动曲线参数3
   *
   * @param enable 物理模型计算运动曲线参数3
   */
  public static setCurveParam3(curveParam: number): void {
    log.showInfo('CURVE-PARAMETER-3 change from %{public}d to %{public}d',
      GravityAnimationConfig.curveParam3, curveParam);
    GravityAnimationConfig.curveParam3 = curveParam;
    GravityAnimationConfig.initialCurve();
  }

  /**
   * 设置物理模型计算运动曲线参数4
   *
   * @param enable 物理模型计算运动曲线参数4
   */
  public static setCurveParam4(curveParam: number): void {
    log.showInfo('CURVE-PARAMETER-4 change from %{public}d to %{public}d',
      GravityAnimationConfig.curveParam4, curveParam);
    GravityAnimationConfig.curveParam4 = curveParam;
    GravityAnimationConfig.initialCurve();
  }

  /**
   * 设置拖拽落位场景引力动效延迟时间
   *
   * @param enable 拖拽落位场景引力动效延迟时间ms
   */
  public static setDelayOnDrop(delayOnDrop: number): void {
    log.showInfo('DELAY-ON-DROP change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnDrop, delayOnDrop);
    GravityAnimationConfig.delayOnDrop = delayOnDrop;
  }

  /**
   * 设置小文件夹找转换为大文件夹场景引力动效延迟时间
   *
   * @param enable 小文件夹找转换为大文件夹场景引力动效延迟时间ms
   */
  public static setDelayOnFolderChangeToBig(delayOnFolderChangeToBig: number): void {
    log.showInfo('DELAY-ON-FOLDER-CHANGE-TO-BIG change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnFolderChangeToBig, delayOnFolderChangeToBig);
    GravityAnimationConfig.delayOnFolderChangeToBig = delayOnFolderChangeToBig;
  }

  /**
   * 设置大文件夹找转换为小文件夹场景引力动效延迟时间
   * @param enable 大文件夹找转换为小文件夹场景引力动效延迟时间ms
   */
  public static setDelayOnFolderChangeToSmall(delayOnFolderChangeToSmall: number): void {
    log.showInfo('DELAY-ON-FOLDER-CHANGE-TO-SMALL change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnFolderChangeToSmall, delayOnFolderChangeToSmall);
    GravityAnimationConfig.delayOnFolderChangeToSmall = delayOnFolderChangeToSmall;
  }

  /**
   * 设置移除图标场景引力动效延迟时间
   *
   * @param enable 移除图标场景引力动效延迟时间ms
   */
  public static setDelayOnRemoveApplication(delayOnRemoveApplication: number): void {
    log.showInfo('DELAY-ON-REMOVE-APPLICATION change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnRemoveApplication, delayOnRemoveApplication);
    GravityAnimationConfig.delayOnRemoveApplication = delayOnRemoveApplication;
  }

  /**
   * 设置移除卡片场景引力动效延迟时间
   *
   * @param enable 移除卡片场景引力动效延迟时间ms
   */
  public static setDelayOnRemoveCard(delayOnRemoveCard: number): void {
    log.showInfo('DELAY-ON-REMOVE-CARD change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnRemoveCard, delayOnRemoveCard);
    GravityAnimationConfig.delayOnRemoveCard = delayOnRemoveCard;
  }

  /**
   * 设置添加卡片到桌面场景引力动效延迟时间
   *
   * @param enable 添加卡片到桌面场景引力动效延迟时间ms
   */
  public static setDelayOnAddCard(delayOnAddCard: number): void {
    log.showInfo('DELAY-ON-ADD-CARD change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnAddCard, delayOnAddCard);
    GravityAnimationConfig.delayOnAddCard = delayOnAddCard;
  }

  /**
   * 设置拖拽图标合并成文件夹场景引力动效延迟时间
   *
   * @param enable 拖拽图标合并成文件夹场景引力动效延迟时间ms
   */
  public static setDelayOnMergeAsFolder(delayOnMergeAsFolder: number): void {
    log.showInfo('DELAY-ON-MERGE-AS-FOLDER change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnMergeAsFolder, delayOnMergeAsFolder);
    GravityAnimationConfig.delayOnMergeAsFolder = delayOnMergeAsFolder;
  }

  /**
   * 设置拖拽图标合落入文件夹场景引力动效延迟时间
   *
   * @param enable 拖拽图标合落入文件夹场景引力动效延迟时间ms
   */
  public static setDelayOnAddToFolder(delayOnAddToFolder: number): void {
    log.showInfo('DELAY-ON-ADD-TO-FOLDER change from %{public}d to %{public}d',
      GravityAnimationConfig.delayOnAddToFolder, delayOnAddToFolder);
    GravityAnimationConfig.delayOnAddToFolder = delayOnAddToFolder;
  }

  /**
   * 恢复配置
   */
  public static reset(configPath?: string): void {
    let jsonData = GravityAnimationConfig.loadProfile(configPath);
    GravityAnimationConfig.setEnable(GravityAnimationConfig.loadNumberData(jsonData, 'enable',
      GravityAnimationConfig.DISABLE));

    GravityAnimationConfig.setMaxRadius(GravityAnimationConfig.loadNumberData(jsonData, 'maxRadius',
      GravityAnimationConfig.MAX_RADIUS));
    GravityAnimationConfig.setMinRadius(GravityAnimationConfig.loadNumberData(jsonData, 'minRadius',
      GravityAnimationConfig.MIN_RADIUS));
    GravityAnimationConfig.setWaveSpeed(GravityAnimationConfig.loadNumberData(jsonData, 'waveSpeed',
      GravityAnimationConfig.WAVE_SPEED));
    GravityAnimationConfig.setWaveRangeConstant(GravityAnimationConfig.loadNumberData(jsonData, 'waveRangeConstant',
      GravityAnimationConfig.WAVE_AMPLITUDE_CONSTANT));
    GravityAnimationConfig.setWaveDuration(GravityAnimationConfig.loadNumberData(jsonData, 'waveDuration',
      GravityAnimationConfig.WAVE_DURATION));

    GravityAnimationConfig.setCurve(GravityAnimationConfig.loadStringData(jsonData, 'curve',
      GravityAnimationConfig.CURVE));
    GravityAnimationConfig.setCurveParam1(GravityAnimationConfig.loadNumberData(jsonData, 'curveParam1',
      GravityAnimationConfig.CURVE_PARAMETER1));
    GravityAnimationConfig.setCurveParam2(GravityAnimationConfig.loadNumberData(jsonData, 'curveParam2',
      GravityAnimationConfig.CURVE_PARAMETER2));
    GravityAnimationConfig.setCurveParam3(GravityAnimationConfig.loadNumberData(jsonData, 'curveParam3',
      GravityAnimationConfig.CURVE_PARAMETER3));
    GravityAnimationConfig.setCurveParam4(GravityAnimationConfig.loadNumberData(jsonData, 'curveParam4',
      GravityAnimationConfig.CURVE_PARAMETER4));

    GravityAnimationConfig.setDelayOnDrop(GravityAnimationConfig.loadNumberData(jsonData, 'delayOnDrop',
      GravityAnimationConfig.DELAY_ON_DROP));
    GravityAnimationConfig.setDelayOnFolderChangeToBig(GravityAnimationConfig.loadNumberData(jsonData,
      'delayOnFolderChangeToBig', GravityAnimationConfig.DELAY_ON_FOLDER_CHANGE_TO_BIG));
    GravityAnimationConfig.setDelayOnFolderChangeToSmall(GravityAnimationConfig.loadNumberData(jsonData,
      'delayOnFolderChangeToSmall', GravityAnimationConfig.DELAY_ON_FOLDER_CHANGE_TO_SMALL));
    GravityAnimationConfig.setDelayOnRemoveApplication(GravityAnimationConfig.loadNumberData(jsonData,
      'delayOnRemoveApplication', GravityAnimationConfig.DELAY_ON_REMOVE_APPLICATION));
    GravityAnimationConfig.setDelayOnRemoveCard(GravityAnimationConfig.loadNumberData(jsonData,
      'delayOnRemoveCard', GravityAnimationConfig.DELAY_ON_REMOVE_CARD));
    GravityAnimationConfig.setDelayOnAddCard(GravityAnimationConfig.loadNumberData(jsonData,
      'delayOnAddCard', GravityAnimationConfig.DELAY_ON_ADD_CARD));
  }

  /**
   * 获取是否开启引力动效
   *
   * @returns  开启引力动效
   */
  public static isEnable(): boolean {
    return GravityAnimationConfig.enable > 0;
  }

  /**
   * 获取引力范围上限
   *
   * @returns  引力范围上限
   */
  public static getMaxRadius(): number {
    return GravityAnimationConfig.maxRadius;
  }

  /**
   * 获取引力范围上限放大系数
   *
   * @returns  放大系数
   */
  public static getMaxRadiusFactor(): number {
    return GravityAnimationConfig.maxRadiusFactor;
  }

  /**
   * 获取引力范围下限
   *
   * @returns  引力范围下限
   */
  public static getMinRadius(): number {
    return GravityAnimationConfig.minRadius;
  }

  /**
   * 获取引力传播速度s
   *
   * @returns  引力传播速度
   */
  public static getWaveSpeed(): number {
    return GravityAnimationConfig.waveSpeed;
  }

  /**
   * 获取引力系数G，用物理模型计算运动曲线
   *
   * @returns  引力系数
   */
  public static getWaveRangeConstant(): number {
    return GravityAnimationConfig.waveAmplitudeConstant;
  }

  /**
   * 获取物理模型计算运动曲线持续时间
   *
   * @returns  持续时间（单次）
   */
  public static getWaveDuration(): number {
    return GravityAnimationConfig.waveDuration;
  }

  /**
   * 获取拖拽落位场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnDrop(): number {
    return GravityAnimationConfig.delayOnDrop;
  }

  /**
   * 获取小文件夹找转换为大文件夹场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnFolderChangeToBig(): number {
    return GravityAnimationConfig.delayOnFolderChangeToBig;
  }

  /**
   * 获取大文件夹找转换为小文件夹场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnFolderChangeToSmall(): number {
    return GravityAnimationConfig.delayOnFolderChangeToSmall;
  }

  /**
   * 获取移除图标场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnRemoveApplication(): number {
    return GravityAnimationConfig.delayOnRemoveApplication;
  }

  /**
   * 获取移除卡片场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnRemoveCard(): number {
    return GravityAnimationConfig.delayOnRemoveCard;
  }

  /**
   * 获取添加卡片到桌面场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnAddCard(): number {
    return GravityAnimationConfig.delayOnAddCard;
  }

  /**
   * 获取拖拽图标合并成文件夹场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnMergeAsFolder(): number {
    return GravityAnimationConfig.delayOnMergeAsFolder;
  }

  /**
   * 获取拖拽图标合落入文件夹场景引力动效延迟时间
   *
   * @returns  延迟时间
   */
  public static getDelayOnAddToFolder(): number {
    return GravityAnimationConfig.delayOnAddToFolder;
  }

  /**
   * 获取支持的物理模型计算运动曲线
   *
   * @returns  物理模型计算运动曲线字符串汇总
   */
  public static getCurveList(): string {
    let total: string = '';

    GravityAnimationConfig.curveMap.forEach((item, key) => {
      total += key + '\n';
    })

    return total;
  }

  /**
   * 获取配置的物理模型计算运动曲线描述
   *
   * @returns  配置的物理模型计算运动曲线描述字符串，含配置
   */
  public static getCurveDesc(): string {
    return GravityAnimationConfig.curve + ' with Parameter [ ' + GravityAnimationConfig.curveParam1 + ', ' +
      GravityAnimationConfig.curveParam2 + ', ' + GravityAnimationConfig.curveParam3 + ', ' +
      GravityAnimationConfig.curveParam4 + ']';
  }

  /**
   * 获取配置的物理模型计算运动曲线
   *
   * @returns  配置的物理模型计算运动曲线字符串
   */
  public static getCurveConfig(): Curve | ICurve {
    let res = GravityAnimationConfig.curveMap.get(GravityAnimationConfig.curve);

    if (!res) {
      log.showWarn('invalid curve config %{public}s, use Curve.Linear as default', GravityAnimationConfig.curve);
      return Curve.Linear;
    }
    return res;
  }

  /**
   * 重新加载配置
   */
  public static reloadConfigs(configPath?: string): void {
    let configCallback: ViewCallback = {
      onShow: (): void => {
        log.showInfo('SCB-DESKTOP is showing, reload gravity animation parameters ...');
        GravityAnimationConfig.reset(configPath);
        GravityAnimationConfig.initialCurve();
        viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, configCallback);
      }
    };
    if (viewMgrPolicy.isViewShowing(ViewType.DESKTOP)) {
      log.showWarn('SCB-DESKTOP is showing, reload gravity animation');
      GravityAnimationConfig.reset(configPath);
      GravityAnimationConfig.initialCurve();
    } else {
      viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, configCallback);
    }
  }
}

/**
 * 加载gravity_animation_parameter.json配置
 */
function loadConfigs(): void {
  let configCallback: ViewCallback = {
    onShow: (): void => {
      log.showInfo('SCB-DESKTOP is showing, load gravity animation parameters ...');
      GravityAnimationConfig.initial();
      viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, configCallback);
    }
  };
  if (viewMgrPolicy.isViewShowing(ViewType.DESKTOP)) {
    log.showWarn('SCB-DESKTOP is showing on booting? load gravity animation parameters right now ...');
    GravityAnimationConfig.initial();
  } else {
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, configCallback);
  }
}

loadConfigs();