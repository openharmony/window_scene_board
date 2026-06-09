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
import { AnimateExCallback } from '@ohos/windowscene/Index';
import { ResizeConfig, ResizeHotArea, ResizePosition } from '../../../common/FolderResizeConstants';
import { FolderCommonUtil } from '../FolderCommonUtil';
import { FolderResizeUtil, ResizeBarVisible } from '../../contractedfolder/viewmodel/layout/resize/FolderResizeUtil';
import {
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutStyleFactory
} from '../../contractedfolder/viewmodel/layout/style/ContractedFolderLayoutStyleFactory';
import { ATTRIBUTE_TYPE } from '../FolderCommonConstant';
import { BaseObserver } from './BaseObserver';
import { ResizeObserverImpl } from './ResizeObserverImpl';

const TAG: string = 'ResizeObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹调整大小
 */
@ObservedV2
export class ResizeObserver extends BaseObserver implements ResizeObserverImpl {
  /**
   * 拖拽把手显示
   */
  @Trace public barVisible: ResizeBarVisible = new ResizeBarVisible(true, true, true, true);
  /**
   * 当前拖拽热区
   */
  @Trace public resizePosition: ResizePosition = ResizePosition.NONE;
  /**
   * 文件夹宽度
   */
  @Trace public folderWidth: number = 0;
  /**
   * 文件夹高度
   */
  @Trace public folderHeight: number = 0;
  /**
   * 组件的对齐方式
   */
  @Trace public alignment: Alignment = Alignment.Center;
  /**
   * Relative的组件对齐方式
   */
  @Trace public alignRules: AlignRuleOption = {
    center: { anchor: '__container__', align: VerticalAlign.Center },
    middle: { anchor: '__container__', align: HorizontalAlign.Center}
  };
  /**
   * 文件夹名水平位移
   */
  @Trace public nameTransX: number = 0;
  /**
   * 文件夹名竖直位移
   */
  @Trace public nameTransY: number = 0;
  /**
   * 宽度为1的文件夹宽度补偿值
   */
  @Trace public gapWidth: number = 0;
  /**
   * 背板圆角
   */
  @Trace public backgroundRadius: number = 16;
  /**
   * 图标zIndex列表
   */
  @Trace public zIndexArray: number[] = new Array(FolderCommonUtil.getContractedFolderMaxShowIconNum([4, 2]));

  /**
   * 初始化
   * @param style
   */
  public init(style: ContractedFolderLayoutStyle): void {
    this.folderWidth = style.backgroundWidth;
    this.folderHeight = style.backgroundHeight;
    this.backgroundRadius = style.backgroundRadius;
  }

  public getAttribute(type: number): number {
    switch (type) {
      case ATTRIBUTE_TYPE.WIDTH:
        return this.folderWidth;
      case ATTRIBUTE_TYPE.HEIGHT:
        return this.folderHeight;
      case ATTRIBUTE_TYPE.BORDER_RADIUS:
        return this.backgroundRadius;
      default:
        return super.getAttribute(type);
    }
  }

  public setAttribute(type: number, value: number): void {
    switch (type) {
      case ATTRIBUTE_TYPE.BORDER_RADIUS:
        this.backgroundRadius = value;
        break;
      default:
        return super.setAttribute(type, value);
    }
  }

  setZIndex(index: number, zIndex: number): void {
    this.zIndexArray[index] = zIndex;
  }

  getZIndex(index: number): number {
    return this.zIndexArray[index];
  }

  setNameTransX(translate: number): void {
    this.nameTransX = translate;
  }

  getNameTransX(): number {
    return this.nameTransX;
  }

  setNameTransY(translate: number): void {
    this.nameTransY = translate;
  }

  getNameTransY(): number {
    return this.nameTransY;
  }

  refreshHotArea(hotArea: ResizeHotArea, isRefreshAlign: boolean): void {
    this.resizePosition = hotArea.position;
    this.barVisible = FolderResizeUtil.getBarVisible(hotArea.position);
    if (isRefreshAlign) {
      this.alignment = hotArea.alignContent;
      this.alignRules = FolderResizeUtil.getAlignRules(hotArea.position);
    }
  }

  getHotAreaPosition(): number {
    return this.resizePosition;
  }

  getBgAnimatorEvent(resizeConfig: ResizeConfig, gapWidth?: number): AnimateExCallback {
    let scaleX: number = resizeConfig.width / this.folderWidth;
    let scaleY: number = resizeConfig.height / this.folderHeight;
    let style: ContractedFolderLayoutStyle = ContractedFolderLayoutStyleFactory.getInstance()
      .getStyleByArea(resizeConfig.area);
    return () => {
      if (gapWidth !== undefined) {
        this.gapWidth = gapWidth;
      }
      this.scaleX = scaleX;
      this.scaleY = scaleY;
      this.offsetX = resizeConfig.offsetX;
      this.offsetY = resizeConfig.offsetY;
      this.nameTransX = resizeConfig.nameTransX;
      this.nameTransY = resizeConfig.nameTransY;
      this.backgroundRadius = style.backgroundRadius;
    };
  }

  getBgReboundX(resizeConfig: ResizeConfig): AnimateExCallback {
    let scaleX: number = resizeConfig.width / this.folderWidth;
    return () => {
      this.scaleX = scaleX;
      this.nameTransX = resizeConfig.nameTransX;
    };
  }

  getBgReboundY(resizeConfig: ResizeConfig): AnimateExCallback {
    let scaleY: number = resizeConfig.height / this.folderHeight;
    return () => {
      this.scaleY = scaleY;
      this.nameTransY = resizeConfig.nameTransY;
    };
  }

  resetBgParams(): void {
    this.scaleX = 1;
    this.scaleY = 1;
    this.offsetX = 0;
    this.offsetY = 0;
    this.nameTransX = 0;
    this.nameTransY = 0;
  }
}