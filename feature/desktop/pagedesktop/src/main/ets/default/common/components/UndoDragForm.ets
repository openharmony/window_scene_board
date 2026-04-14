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
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { LengthMetrics } from '@kit.ArkUI';
import componentUtils from '@ohos.arkui.componentUtils';
import {
  CardItemInfo,
  FormModel,
  StyleConstants,
  PageDesktopModel,
  editModeManager,
} from '@ohos/launchercommon';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  HiSysEventUtil,
  ResultType,
  ViewManagerPolicy,
  ViewType,
  TextColor,
  WallpaperColorManager
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import EditModeStyleConstants from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeStyleConstants';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import FeatureConstants from '../constants/FeatureConstants';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'UndoDragDrop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct UndoDragForm {
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  @Prop singleContext?: SingleContext;
  @StorageProp('undoDragFormVisible') undoDragFormVisible: boolean = false;
  @State isDragFormEnter: boolean = false;
  @State bottomHotAreaSize: number = 0;
  @State leftHotAreaSize: number = 0;
  @State backboardColor: string = EditModeStyleConstants.EDIT_MODE_BUTTON_DEFAULT_BG_COLOR;
  // 按钮背板模糊饱和度
  @State saturation: number = FeatureConstants.FORM_UNDO_BUTTON_BG_EFFECT_NORMAL_SATURATION;
  @StorageProp('wallpaperChangeFlag') @Watch('wallpaperChange') wallpaperValue: boolean = true;
  @Consume('isFoldProductFold') @Watch('outerFoldStatusChange') isFoldProductFold: boolean;
  private mFormModel: FormModel = FormModel.getInstance();
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);

  private undoHotAreaChange(leftHotAreaSize: number, bottomHotAreaSize: number): void {
    this.leftHotAreaSize = leftHotAreaSize;
    this.bottomHotAreaSize = bottomHotAreaSize;
    this.updateBackboardColor();
    log.showInfo(`left:${this.leftHotAreaSize}, bottom:${this.bottomHotAreaSize}`);
  }

  private wallpaperChange(): void {
    log.showInfo('wallpaper change.');
    this.updateBackboardColor();
  }

  private outerFoldStatusChange(): void {
  }

  /**
   * 撤销按钮背板颜色跟随桌面文字
   */
  private updateBackboardColor() {
    let textColor: TextColor | undefined = launcherStatusUtil.getShowOutLauncherStatus() ?
    WallpaperColorManager.getInstance().mOuterTextColor : WallpaperColorManager?.getInstance()?.mTextColor;
    if (textColor === undefined || textColor.mTextColor === undefined) {
      log.showError('textColor params error');
      return;
    }
    let colorStr: string = textColor.mTextColor;
    this.backboardColor =
      colorStr.substring(0, 1) + FeatureConstants.FORM_UNDO_BUTTON_BG_COLOR_OPACITY + colorStr.substring(1);
    this.saturation = colorStr.toLowerCase() === '#000000' ?
      FeatureConstants.FORM_UNDO_BUTTON_BG_EFFECT_LIGHT_SATURATION :
      FeatureConstants.FORM_UNDO_BUTTON_BG_EFFECT_NORMAL_SATURATION;
    log.showInfo(`colorStr: ${colorStr}, backboardColor: ${this.backboardColor}, saturation: ${this.saturation}`);
  }

  /**
   * 暂态卡片撤销
   */
  undoDragDrop() {
    log.showInfo('undoDragDrop');
    this.isDragFormEnter = false;
    AppStorage.setOrCreate('undoDragFormVisible', false);
    AppStorage.setOrCreate('isFormShowMask', false);
    if (!editModeManager.isInEditMode()) {
      ViewManagerPolicy.showView(ViewType.STATUS_BAR);
    }
    const dragItemInfo: CardItemInfo = AppStorage.get('dragItemInfo') as CardItemInfo;
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    this.mPageDesktopViewModel?.reportAddCardToScreenByDragEvent(dragItemInfo, dragItemType, ResultType.UNDO);
    this.mFormModel.deleteFormByFormIdStr(dragItemInfo.id);
    this.leftHotAreaSize = 0;
    this.bottomHotAreaSize = 0;
    AppStorage.setOrCreate('selectAppIndex', null);
    AppStorage.setOrCreate('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
  }

  @Styles
  unDragFormButtonStyle() {
    .id(`${TAG}_button_undo`)
    .height(DeviceHelper.isFoldButNotSmallFoldProduct() ? StyleConstants.DEFAULT_24 : StyleConstants.DEFAULT_32)
    .width(DeviceHelper.isFoldButNotSmallFoldProduct() ? StyleConstants.DEFAULT_52 : StyleConstants.DEFAULT_60)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .shadow({
      radius: FeatureConstants.FORM_UNDO_BUTTON_SHADOW_RADIUS,
      color: FeatureConstants.FORM_UNDO_BUTTON_SHADOW_COLOR,
      offsetY: FeatureConstants.FORM_UNDO_BUTTON_SHADOW_OFFSET_Y
    })
    .margin({
      end: LengthMetrics.vp(StyleConstants.DEFAULT_24),
      top: LengthMetrics.vp(StyleConstants.DEFAULT_16)
    })
    .backgroundColor(this.isDragFormEnter ? EditModeStyleConstants.EDIT_MODE_BUTTON_REMOVE_BG_COLOR :
      this.backboardColor)
    .backgroundEffect({
      policy: 1,
      radius: FeatureConstants.FORM_UNDO_BUTTON_BG_EFFECT_RADIUS,
      saturation: this.saturation,
    }, { disableSystemAdaptation: true })
  }

  aboutToAppear(): void {
    log.showInfo('undo drag form aboutToAppear.');
    this.desktopContext?.eventHub.on(FormConstants.EVENTHUB_FORM_MANAGER_UNDO_HOT_AREA,
      (leftHotAreaSize: number, bottomHotAreaSize: number) =>
      this.undoHotAreaChange(leftHotAreaSize, bottomHotAreaSize));
  }

  build() {
    if (this.undoDragFormVisible) {
      Stack({ alignContent: Alignment.End }) {
        Stack() {
          Button({ type: ButtonType.Capsule }) {
            Stack() {
              Image($r('app.media.ic_form_undo')).draggable(false)
                .id(`${TAG}_image_undo`)
                .fillColor($r('sys.color.ohos_id_color_primary_dark'))
                .size({ width: StyleConstants.DEFAULT_20, height: StyleConstants.DEFAULT_20 })
            }.id(`${TAG}_stack_undo`)
          }
          .unDragFormButtonStyle()
        }
        .padding({
          bottom: LengthMetrics.vp(this.bottomHotAreaSize),
          start: LengthMetrics.vp(this.leftHotAreaSize)
        })
        .onDragEnter((event?: DragEvent, extraParams?: string) => {
          this.isDragFormEnter = true;
          editModeViewManager.refreshDragItemColor(true, true);
          AppStorage.setOrCreate('isFormShowMask', true);
          this.desktopContext?.eventHub.emit(`rect${PageDesktopModel.getInstance().getPageIndex()}`, false, false, [0, 0]);
          this.mPageDesktopDragHandler.onDragLeave(0, 0);
          log.showInfo(`Undo onDragEnter extraParams: ${extraParams}, event: [${event?.getX()}, ${event?.getY()}]`);
        })
        .onDragMove((event?: DragEvent, extraParams?: string) => {
          log.showInfo(`Undo onDragMove event: [${event?.getX()}, ${event?.getY()}]`);
        })
        .onDragLeave((event?: DragEvent, extraParams?: string) => {
          this.isDragFormEnter = false;
          editModeViewManager.refreshDragItemColor(false);
          AppStorage.setOrCreate('isFormShowMask', false);
          log.showInfo(`Undo onDragLeave event: [${event?.getX()}, ${event?.getY()}]`);
        })
        .onDrop((event?: DragEvent, extraParams?: string) => {
          performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
          TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
          log.showInfo(`Undo onDrop status event: [${event?.getX()}, ${event?.getY()}]`);
          if (event) {
            event.useCustomDropAnimation = true;
          }
          this.mPageDesktopDragHandler.deleteBlankPageAfterDragging(null, 'undoDrag onDrop');
          this.undoDragDrop();
        })
      }
      .id(TAG + '_Stack_UndoDragForm')
      .zIndex(1)
      .width(StyleConstants.PERCENTAGE_100)
      .position({ x: FeatureConstants.FORM_UNDO_POSITION, y: FeatureConstants.FORM_UNDO_POSITION })
    }
  }
}