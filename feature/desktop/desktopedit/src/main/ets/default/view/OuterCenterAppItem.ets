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

import { CheckEmptyUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { ResourceManager, IconResourceManager } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { SnapshotType, dragSnapshotHelper } from '@ohos/componenthelper';
import {
  AppItemInfo,
  EditModeConstants,
  EditModeUtils,
  GridLayoutItemInfo,
  HiEditModeEventUtils,
  vibratorMgr
} from '@ohos/launchercommon';
import {
  OuterPageDesktopViewModelProxy,
  IOuterPageDesktopViewModel
} from '@ohos/launchercommon/Index';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';
import { ImageModifier } from '@ohos.arkui.modifier';
import { AppIconItemData } from '../viewmodel/OuterEditCenterObservedData';
import { AppIconViewEvent } from '../viewmodel/AppIconViewEvent';
import { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'OuterCenterAppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct OuterCenterAppItem {
  startType: StartType = StartType.APP;
  extraId?: string;
  @State appIcon: string | PixelMap | Resource = '';
  @State appName: string = '';
  @State dragSnapshot: PixelMap | undefined = undefined;
  @Prop iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @State mFormLongPressHide: boolean = false;
  @State animateData: AppIconItemData = new AppIconItemData();
  @Link iconSize: number;
  @Prop @Watch('updateOuterAppSearchResult') matchedText: string = '';
  @State searchResult: string[] = [];
  private avatarIDResource?: Resource;
  private appItem: AppItemInfo = new AppItemInfo();
  private idIndex: number = 0;
  private itemWidth: number = 0;
  private iconRate: number = 1;
  private mEvent: AppIconViewEvent = new AppIconViewEvent();
  private mCancelFormHideTimer: number = 0;
  private mOuterIconCenterViewManager: OuterIconCenterViewManager = OuterIconCenterViewManager.getInstance();
  private addAppToDeskTopCallBack?: () => void;

  async aboutToAppear(): Promise<void> {
    let resourceManager: ResourceManager = ResourceManager.getInstance();
    this.appName = this.appItem.applicationName as string;
    if (CheckEmptyUtils.checkStrIsEmpty(this.appName)) {
      resourceManager.getAppNameSync(this.appItem.appLabelId,
        this.appItem.bundleName, this.appItem.moduleName, '').then((appName) => {
        this.appName = appName;
      });
    }
    this.appIcon = await IconResourceManager.getInstance().getCombIcon(this.appItem.bundleName, this.appItem.moduleName,
      this.appItem.abilityName, undefined, 'CombIcon_OuterCenterAppItem');
    // 初始化typeId
    this.appItem.typeId = 0;
    this.mEvent.initData(this.animateData);
    this.updateOuterAppSearchResult()
    if (!CheckEmptyUtils.isEmpty(this.appItem.appIndex)) {
      this.avatarIDResource = EditModeConstants.APP_INDEX_RESOURCE_MAP.get(this.appItem.appIndex as number);
    }
  }

  aboutToDisappear(): void {
    this.mFormLongPressHide = false;
  }

  private updateOuterAppSearchResult() {
    this.searchResult = this.mOuterIconCenterViewManager.updateSearchResult(this.matchedText, this.appName);
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction((): void => {
            this.mEvent.longPressHandler(this.idIndex);
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction(() => {
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LONG_PRESS,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          }),
        LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_FLOATING_EFFECT })
          .onAction(() => {
            clearTimeout(this.mCancelFormHideTimer);
          }),
      )
    )
  }

  @Styles
  dragStyles() {
    .draggable(true)
    .onDragStart((event: DragEvent, extraParams?: string) => {
      log.showInfo(`OuterCenterAppItem onDragStart`);
      let gInfo: GridLayoutItemInfo = this.appItemToGridLayoutItemInfo(this.appItem);
      AppStorage.setOrCreate('OuterAppItem', gInfo);
      return this.mEvent.onDragStart(event, this.appItem, this.itemWidth);
    })
    .onDragEnd((event: DragEvent) => {
      log.showInfo(`OuterCenterAppItem onDragEnd`);
      this.mEvent.onDragEnd();
    })
    .dragPreview({
      pixelMap: this.dragSnapshot
    })
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier().borderRadius(this.iconRadius * this.iconRate)
    })
  }

  private appItemToGridLayoutItemInfo(appItemInfo: AppItemInfo): GridLayoutItemInfo {
    let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    if (appItemInfo == undefined) {
      log.showInfo(`appItemToGridLayoutItemInfo appItemInfo error: ${appItemInfo}`)
      return gInfo;
    }
    gInfo.bundleName = this.appItem.bundleName;
    gInfo.abilityName = this.appItem.abilityName;
    gInfo.moduleName = this.appItem.moduleName;
    gInfo.typeId = 0;
    gInfo.badgeNumber = this.appItem.badgeNumber;
    gInfo.appIconId = this.appItem.appIconId;
    gInfo.appLabelId = this.appItem.appLabelId;
    gInfo.infoName = this.appItem.appName;
    gInfo.appName = this.appName.toString();
    gInfo.appStatus = 0;
    gInfo.negativeId = 0;
    gInfo.isSelect = false;
    gInfo.enterEditing = false;
    gInfo.iconResource = '';
    gInfo.callerName = '';
    gInfo.area = [1, 1];
    gInfo.size = this.itemWidth;
    gInfo.appIndex = this.appItem.appIndex;
    gInfo.shortcutId = this.appItem.shortcutId;
    gInfo.keyName = AppItemInfo.getKeyName(this.appItem);
    return gInfo;
  }

  /**
   * 获得AppItem的左上角位置信息
   *
   * @returns AppItem的左上角位置信息
   */
  private getAppItemPosition(): Position {
    // 根据ID获取组件对象
    let pos: object = JSON.parse(getInspectorByKey(`OuterApp_Icon_${this.appName}_${this.idIndex}`));
    // 将位置信息解析成string
    let strRect: string = pos['$rect'];
    // 获取其左边及上方位置信息
    let rectInfo: string = JSON.parse('[' + strRect + ']');
    let rectLeft: string = JSON.parse('[' + rectInfo[0] + ']')[0];
    let rectTop: string = JSON.parse('[' + rectInfo[0] + ']')[1];
    return { x: px2vp(parseInt(rectLeft)), y: px2vp(parseInt(rectTop)) };
  }

  private addAppToDeskTop(): void {
    let gInfo = this.appItemToGridLayoutItemInfo(this.appItem);
    let isAreaEnough: boolean = OuterPageDesktopViewModelProxy.getInstance().outerHasAppItemEnoughArea(gInfo);
    if (!isAreaEnough) {
      log.showInfo('no space add app')
      OuterPageDesktopViewModelProxy.getInstance().showNoSpaceToast(true);
      return;
    }
    OuterIconCenterViewManager.getInstance().setOuterAppIsEnable(false);
    // 等待触摸动效完成, 触发点击动效
    setTimeout(() => {
      this.mEvent.startItemClickAnim(this.appName, this.addAppToDeskTopCallBack);
    }, EditModeStyleConstants.OUTER_PRESS_ANIMATE_DURATION);
    this.startAppItemMotion(gInfo);
  }

  private startAppItemMotion(gInfo: GridLayoutItemInfo): void {
    OuterPageDesktopViewModelProxy.getInstance().addOuterAppItemToDeskTop(gInfo, () => {
    }, (position: number[], page?: number) => {
      gInfo.row = position[0];
      gInfo.column = position[1];
      gInfo.page = page;
      HiEditModeEventUtils.reportAddAppToScreenByClick(this.appItem, position[0], position[1], page);
    });
  }

  @Styles
  shadowStyle() {
    .shadow({
      radius: $r('app.float.outer_normal_form_center_radius'),
      color: $r('app.color.outer_normal_form_center_shadow_color')
    })
  }

  build() {
      RelativeContainer() {
        RelativeContainer() {
          Image(this.appIcon)
            .draggable(false)
            .id(`OuterApp_Icon_${this.appName}_${this.idIndex}`)
            .width(this.itemWidth)
            .height(this.itemWidth)
            .borderRadius(this.iconRadius * this.iconRate)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .longPressGestureStyles()
            .dragStyles()
            .accessibilityText(this.appName)
            .onClick((event) => {
              if (!OuterIconCenterViewManager.getInstance().getOuterAppIsEnable()) {
                return;
              }
              this.addAppToDeskTop()
            })
            .onTouch((event: TouchEvent) => {
              if (!OuterIconCenterViewManager.getInstance().getOuterAppIsEnable()) {
                return;
              }
              log.showInfo(`event.type=${event.type}`)
              if (this.appName == undefined) {
                return;
              }
              if (event?.type === TouchType.Down && !this.dragSnapshot) {
                dragSnapshotHelper.snapshotFromId(`OuterApp_Icon_${this.appName}_${this.idIndex}`, SnapshotType.BOTH,
                  `${this.appItem.typeId}${this.appItem.bundleName}${this.appItem.appIndex ?? 0}`,
                  (value: PixelMap) => {
                    this.dragSnapshot = value;
                    log.showInfo(`cache app=${this.appName}, ${this.appItem.bundleName}`)
                    const cacheKey: string = `${this.appName}${this.appItem.bundleName}${this.appItem.moduleName}`;
                    ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
                  }, undefined, undefined, `OuterCenter_onTouch`);
              }
              if ((event?.type === TouchType.Up || event?.type === TouchType.Cancel) && this.mFormLongPressHide) {
                this.mCancelFormHideTimer = setTimeout(() => {
                  log.showInfo('touch up, resume form visible.');
                  this.mFormLongPressHide = false;
                }, CommonConstants.RESTORE_TIME_FOR_FLOATING_EFFECT);
              }
              this.mEvent.onTouch(event);
            })
            .opacity(this.mFormLongPressHide ? EditModeStyleConstants.OUTER_APP_ITME_IMAGE_OPACITY : 1)

          if (!CheckEmptyUtils.isEmpty(this.avatarIDResource)) {
            Image(this.avatarIDResource)
              .draggable(false)
              .width(EditModeConstants.APP_INDEX_IMAGE_SIZE)
              .height(EditModeConstants.APP_INDEX_IMAGE_SIZE)
              .syncLoad(true)
              .alignRules({
                right: { anchor: `OuterApp_Icon_${this.appName}_${this.idIndex}`, align: HorizontalAlign.End },
                bottom: { anchor: `OuterApp_Icon_${this.appName}_${this.idIndex}`, align: VerticalAlign.Bottom }
              })
              .offset({
                start: LengthMetrics.vp(EditModeConstants.APP_INDEX_IMAGE_OFFSET),
                top: LengthMetrics.vp(EditModeConstants.APP_INDEX_IMAGE_OFFSET),
              })
          }
        }
        .id('outer_app_layout')
        .width(this.itemWidth)
        .height(this.itemWidth)
        .borderRadius(this.iconRadius * this.iconRate)
        .scale({ x: this.animateData.iconAnimateScale, y: this.animateData.iconAnimateScale })
        .shadowStyle()

        Text() {
          if (CheckEmptyUtils.checkStrIsEmpty(this.searchResult?.[1])) {
            Span(this.appName)
          } else {
            Span(this.searchResult[0])
            Span(this.searchResult[1]).fontColor($r('sys.color.font_emphasize'))
            Span(this.searchResult[2])
          }
        }
          .draggable(false)
          .id(`OuterApp_Name_${this.appName}_${this.idIndex}`)
          .fontSize(SmallFoldStyleUtil
            .getScaleSize(EditModeStyleConstants.OUTER_APP_ITME_TEXT_FONTSIZE
              , SmallFoldStyleUtil.LEVEL_BIG_3_FONT_SIZE_SCALE))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .width(this.itemWidth)
          .constraintSize({ minHeight: EditModeStyleConstants.OUTER_APP_ITEM_TITLE_HEIGHT })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(EditModeStyleConstants.OUTER_APP_ITEM_TEXT_MAX_LINES)
          .fontWeight(FontWeight.Normal)
          .alignRules({
            top: { anchor: `outer_app_layout`, align: VerticalAlign.Bottom },
            middle: { anchor: `outer_app_layout`, align: HorizontalAlign.Center }
          })
          .margin({ top: EditModeStyleConstants.OUTER_APP_ITME_TEXT_MARGIN_TOP })
      }
      .width(this.itemWidth)
      .height('auto')
      .scale({x: this.animateData.animateScale, y: this.animateData.animateScale})
      .foregroundEffect({ radius: this.animateData.mBlur })
  }
}