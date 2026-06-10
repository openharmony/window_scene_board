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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import CommonConstants, { CcmOption, SlAreaType, SlPositionType } from '../constants/CommonConstants';
import { SlMainStateType, SlStaticStateType } from '../constants/SlStateType';
import { WidgetSize } from '../interface/ISlState';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { SlVisualArgs, SlArea } from './SlVisualData';
import { SlVisualConfigManager, SL_AREA_ARR } from './SlVisualConfigManager';
import { SlVisualSolidUtils } from './SlVisualUtils';

const TAG = 'WidgetAreaManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏元素根组件区域管理，用以计算每个区域的视效、纯色等
 */
export class SlWidgetAreaManager {
  /**
   * 当前锁屏所有区域
   */
  private allArea: Map<SlAreaType, SlArea> = new Map();

  /**
   * 初始化锁屏区域配置
   */
  constructor() {
    SL_AREA_ARR.forEach((areaType: SlAreaType) => {
      this.addArea(areaType);
    });
  }

  /**
   * 查询当前锁屏所有区域
   *
   * @returns 锁屏所有组件区域
   */
  getAllArea(): Map<SlAreaType, SlArea> {
    return this.allArea;
  }

  /**
   * 查询组件区域实例
   *
   * @returns 区域实例
   */
  getArea(slAreaType: SlAreaType): SlArea | undefined {
    return this.allArea.get(slAreaType);
  }

  /**
   * 更新锁屏元素根组件区域坐标
   * 并将组件区域坐标封装到SlArea类型中
   *
   * @param slAreaType 组件区域类型
   * @param area 新的组件坐标
   */
  updateComponentArea(slAreaType: SlAreaType, area: Area): boolean {
    if (!SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID) &&
        SlVisualConfigManager.getInstance().getEnable(CcmOption.BRIGHT)) {
      return false;
    }

    if (!this.getArea(slAreaType) || !area) {
      log.showWarn(`update fail for invalid slArea, slAreaType:${slAreaType}`);
      return false;
    }

    let newPosition: number[] | undefined = this.getNewPostion(slAreaType, area);
    return this.updatePosition(slAreaType, newPosition);
  }

  /**
   * 更新组件区域坐标
   *
   * @param slAreaType 组件区域类型
   * @param newPosition 新坐标
   * @returns 坐标是否更新
   */
  private updatePosition(slAreaType: SlAreaType, newPosition?: number[]): boolean {
    if (!newPosition) {
      return false;
    }
    let slArea = this.allArea.get(slAreaType);
    if (!slArea) {
      return false;
    }
    let isChange = SlVisualSolidUtils.checkAreaChange(slArea.position, newPosition);
    slArea.position = newPosition;
    if (isChange) {
      log.showInfo(`update type:${slAreaType}, area:${slArea.printPosition()}, isChange:${isChange}`);
    }
    return isChange;
  }

  /**
   * 计算组件新的坐标
   *
   * @param slAreaType 组件区域类型
   * @param area 新的组件坐标
   * @returns 组件坐标
   */
  private getNewPostion(slAreaType: SlAreaType, area: Area): number[] | undefined {
    let globalX = area.globalPosition?.x as number ?? CommonConstants.POSITION_ZERO;
    let globalY = area.globalPosition?.y as number ?? CommonConstants.POSITION_ZERO;
    let width = area.width as number ?? CommonConstants.POSITION_ZERO;
    let height = area.height as number ?? CommonConstants.POSITION_ZERO;
    let screenSize = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.
      getSlState(SlStaticStateType.SL_SIZE_STATE) as WidgetSize;

    if (!this.checkScreenSizeValid(screenSize) || !this.checkAreaParamValid(globalX, globalY, width, height)) {
      log.showWarn(`update fail for invalid param, slAreaType:${slAreaType}`);
      return undefined;
    }

    return [globalX / screenSize.width, globalY / screenSize.height,
      (globalX + width) / screenSize.width, (globalY + height) / screenSize.height];
  }

  /**
   * 注册视效参数到对应的组件区域
   *
   * @param args 视效纯色参数
   */
  registerVisualOption(args: SlVisualArgs): void {
    if (!args.areaType || !args.positionType) {
      return;
    }
    this.getArgsArr(args.areaType)?.push(args.positionType);
  }

  /**
   * 注销视效参数
   *
   * @param args 视效参数
   */
  unregisterVisualOption(args: SlVisualArgs): void {
    if (!args.areaType || !args.positionType) {
      return;
    }
    ArrayUtils.deleteArr(this.getArgsArr(args.areaType), args.positionType);
  }

  /**
   * 查询单一组件区域内映射的所有纯色参数
   *
   * @param areaType 组件区域
   * @returns 纯色参数标识
   */
  private getArgsArr(areaType: SlAreaType): SlPositionType[] | undefined {
    return this.getArea(areaType)?.argsArr;
  }

  /**
   * 增加组件区域配置
   *
   * @param slAreaType
   */
  private addArea(slAreaType: SlAreaType): void {
    if (SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID, slAreaType)) {
      this.allArea.set(slAreaType, new SlArea(slAreaType));
    }
  }

  /**
   * 检测当前的屏幕宽度属性合法性
   *
   * @param screenSize 屏幕尺寸
   * @returns true 合法参数
   */
  private checkScreenSizeValid(screenSize: WidgetSize): boolean {
    return screenSize && screenSize.width > 0 && screenSize.height > 0;
  }

  /**
   * 检测从arkUI获取的组件区域参数合法性
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @param width 区域宽度
   * @param height 区域高度
   * @returns true 合法参数
   */
  private checkAreaParamValid(globalX: number, globalY: number, width: number, height: number): boolean {
    return globalX >= 0 && globalY >= 0 && width > 0 && height > 0;
  }
}