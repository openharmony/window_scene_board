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
import { DockContinuableInfo, StyleConstants } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';
import { SCBScreenProperty } from '@ohos/windowscene';
import { ArrowType } from '../../default/common/constants/FixedDockConstants';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../../default/common/PcSmartDockStyleManager';
import PcSmartDockViewModel from '../../default/viewmodel/SmartDockViewModel';
import { EsDockEventManager } from '../viewmodel/event/EsDockEventManager';
import { ExtScreenModeDockViewModel } from '../viewmodel/ExtScreenModeDockViewModel';
import { DockArrowViewData } from '../viewmodel/viewdata/DockArrowViewData';

const TAG = 'DockArrowView';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * Dock栏组件-常驻区或者运行区箭头
 */
@Component
export struct DockArrowView {
  @Link screenProp: SCBScreenProperty;
  private arrowType: ArrowType = ArrowType.RESIDENT_LEFT;
  private isResident: boolean = false;
  @Prop ratio: number = 1;
  @Prop currColorMode: number;
  private mViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private mExtViewModel: ExtScreenModeDockViewModel = ExtScreenModeDockViewModel.getInstance();
  @State viewData: DockArrowViewData = new DockArrowViewData();
  @StorageLink('continueDeviceInfo') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  @State residentLeftArrowOpacity: Resource | number = 1;
  @State residentRightArrowOpacity: Resource | number = 1;
  @State recentLeftArrowOpacity: Resource | number = 1;
  @State recentRightArrowOpacity: Resource | number = 1;
  @State residentLeftArrowBgColor: ResourceColor | null = null;
  @State residentRightArrowBgColor: ResourceColor | null = null;
  @State recentLeftArrowBgColor: Resource | null = null;
  @State recentRightArrowBgColor: Resource | null = null;
  @Link enableScrollInteraction: boolean;
  private arrowUiChangeCallback = (): void => {
    this.residentLeftArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.residentLeftArrowOpacity ?? 1;
    this.residentRightArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.residentRightArrowOpacity ?? 1;
    this.recentLeftArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.recentLeftArrowOpacity ?? 1;
    this.recentRightArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.recentRightArrowOpacity ?? 1;
    this.residentLeftArrowBgColor = this.mExtViewModel.getModelData().arrowModel?.residentLeftArrowBgColor ?? null;
    this.residentRightArrowBgColor = this.mExtViewModel.getModelData().arrowModel?.residentRightArrowBgColor ?? null;
    this.recentLeftArrowBgColor = this.mExtViewModel.getModelData().arrowModel?.recentLeftArrowBgColor ?? null;
    this.recentRightArrowBgColor = this.mExtViewModel.getModelData().arrowModel?.recentRightArrowBgColor ?? null;
  };

  public aboutToAppear(): void {
    logger.showInfo('Start');
    this.initViewData();
    EsDockEventManager.getInstance().registerArrowChangeCallback(this.arrowUiChangeCallback);
  }

  public aboutToDisappear(): void {
    logger.showInfo('Start');
    EsDockEventManager.getInstance().unregisterArrowChangeCallback(this.arrowUiChangeCallback);
  }

  private initViewData(): void {
    this.viewData.screenId = this.mExtViewModel.getModelData().attachedScreenId;
    this.viewData.leftArrowPath =
      this.mExtViewModel.getModelData().arrowModel?.leftArrowPath ?? $r('sys.media.ohos_ic_public_arrow_left');
    this.viewData.rightArrowPath =
      this.mExtViewModel.getModelData().arrowModel?.rightArrowPath ?? $r('sys.media.ohos_ic_public_arrow_right');
    this.viewData.residentLeftArrowOpacity =
      this.mExtViewModel.getModelData().arrowModel?.residentLeftArrowOpacity ?? 1;
    this.viewData.residentRightArrowOpacity =
      this.mExtViewModel.getModelData().arrowModel?.residentRightArrowOpacity ?? 1;
    this.viewData.recentLeftArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.recentLeftArrowOpacity ?? 1;
    this.viewData.recentRightArrowOpacity = this.mExtViewModel.getModelData().arrowModel?.recentRightArrowOpacity ?? 1;
    this.viewData.residentLeftArrowBgColor =
      this.mExtViewModel.getModelData().arrowModel?.residentLeftArrowBgColor ?? null;
    this.viewData.residentRightArrowBgColor =
      this.mExtViewModel.getModelData().arrowModel?.residentRightArrowBgColor ?? null;
    this.viewData.recentLeftArrowBgColor = this.mExtViewModel.getModelData().arrowModel?.recentLeftArrowBgColor ?? null;
    this.viewData.recentRightArrowBgColor =
      this.mExtViewModel.getModelData().arrowModel?.recentRightArrowBgColor ?? null;

    this.arrowUiChangeCallback();

    this.viewData.isResidentLeftArrowClickable =
      this.mExtViewModel.getModelData().arrowModel?.isResidentLeftArrowClickable ?? true;
    this.viewData.isResidentRightArrowClickable =
      this.mExtViewModel.getModelData().arrowModel?.isResidentRightArrowClickable ?? true;
    this.viewData.isRecentLeftArrowClickable =
      this.mExtViewModel.getModelData().arrowModel?.isRecentLeftArrowClickable ?? true;
    this.viewData.isRecentRightArrowClickable =
      this.mExtViewModel.getModelData().arrowModel?.isRecentRightArrowClickable ?? true;
  }

  private getArrowPath(arrowType: ArrowType): ResourceStr {
    return this.mViewModel.isLeftArrow(arrowType) ? this.viewData.leftArrowPath : this.viewData.rightArrowPath;
  }

  private getArrowOpacity(arrowType: ArrowType): Resource | number {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT:
        return this.residentLeftArrowOpacity;
      case ArrowType.RESIDENT_RIGHT:
        return this.residentRightArrowOpacity;
      case ArrowType.RECENT_LEFT:
        return this.recentLeftArrowOpacity;
      case ArrowType.RECENT_RIGHT:
        return this.recentRightArrowOpacity;
      default:
        logger.showError('getArrowOpacity:invalid arrow type');
        return 0;
    }
  }

  private getArrowBackgroundColor(arrowType: ArrowType): ResourceColor | null {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT:
        return this.residentLeftArrowBgColor;
      case ArrowType.RESIDENT_RIGHT:
        return this.residentRightArrowBgColor;
      case ArrowType.RECENT_LEFT:
        return this.recentLeftArrowBgColor;
      case ArrowType.RECENT_RIGHT:
        return this.recentRightArrowBgColor;
      default:
        logger.showError('getArrowBackgroundColor:invalid arrow type');
        return null;
    }
  }

  private getArrowLeftMargin(arrowType: ArrowType): number {
    return 0;
  }

  private getArrowRightMargin(arrowType: ArrowType): number {
    return 0;
  }

  private isDarkMode(): boolean {
    return this.currColorMode === 0;
  }

  build() {
    Row() {
      Image(this.getArrowPath(this.arrowType))
        .draggable(false)
        .id(this.mViewModel.getDockArrowId(this.isResident, this.arrowType))
        .objectFit(ImageFit.Fill)
        .width(StyleConstants.DEFAULT_24)
        .height(StyleConstants.DEFAULT_24)
        .fillColor(this.isDarkMode() ? '#E5FFFFFF' : '#E5000000')
        .opacity(this.getArrowOpacity(this.arrowType))
        .matchTextDirection(true)
    }
    .width(PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowWidth)
    .height(PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowHeight)
    .backgroundColor(this.getArrowBackgroundColor(this.arrowType))
    .borderRadius(StyleConstants.DEFAULT_8)
    .margin({
      left: this.getArrowLeftMargin(this.arrowType),
      right: this.getArrowRightMargin(this.arrowType)
    })
    .justifyContent(FlexAlign.Center)
    .onHover((isHover) => {
      this.mExtViewModel.handleArrowHover(this.arrowType, isHover, this.viewData);
    })
    .onClick(() => {
      if (!this.enableScrollInteraction) {
        return;
      }
      this.mExtViewModel.handleArrowClick(this.arrowType, this.viewData);

      logger.showInfo(` 1SI-${(this.residentRightArrowOpacity as Resource).id} - ${this.residentRightArrowBgColor ===
        null}`);
      logger.showInfo(` 2SI-${(this.residentLeftArrowOpacity as Resource).id} - ${this.residentLeftArrowBgColor ===
        null}`);
    })
    .onTouch((event?: TouchEvent) => {
      this.mExtViewModel.handleArrowTouch(this.arrowType, this.isDarkMode(), event, this.viewData);
    })
  }
}