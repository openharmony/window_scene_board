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

import { LogDomain, LogHelper, Trace, PixelMapUtil } from '@ohos/basicutils';
import { ActionType, ThreeFingersSwipe } from '@ohos.multimodalInput.gestureEvent';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { GlobalContext, HiDfxEventUtil, localEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import image from '@ohos.multimedia.image';
import { SCBSceneSessionManager, SCBScreenProperty, SCBSessionRect} from '@ohos/windowscene';
import { LengthMetrics, screenshot } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';
import { systemDateTime } from '@kit.BasicServicesKit';
import { IUserData } from '@ohos/screenlockcommon';
import accountModel from '../screenlock/refactor/AccountsModel';
import { SwipeGestureDirection } from '@ohos/pcmode';
import {
  MultiSpace,
  MultiSpaceSwitchOneGoCtrl,
  SwitchEnterpriseMultiSpaceType
} from '../../common/EnterpriseMultiSpaceController';
import { FixedDockResource } from '@ohos/pcsmartdock/src/main/ets/default/common/constants/FixedDockConstants';
import { DockBackgroundMgr } from '@ohos/pcsmartdock';
import { FourFingerSwipeController } from '../virtualmachine/FourFingerSwipeController';
import { DesktopSwitchController } from '../virtualmachine/DesktopSwitchController';

const TAG = 'EnterpriseRecentPanel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const ENTERPRISE_VM_SNAPSHOT_PIXEL_MAP_NAME: string = 'enterpriseVmSnapshot_Pixel_Map';

enum SpaceType {
  Enterprise, Personal
};

interface ScreenshotOptionsImpl extends screenshot.ScreenshotOptions {
  isCaptureFullOfScreen?: boolean;
}

@Observed
class Space {
  public static readonly ENTERPRISE_ID: number = 100;
  public id: number = Space.ENTERPRISE_ID;
  public name: string = '';
  public type: SpaceType = SpaceType.Enterprise;
  public isCurrent: boolean = false;
  public hasVm: boolean = false
}

class DesktopSnapshot {
  private screenshotPixel: Promise<image.PixelMap | undefined> | undefined = undefined;

  take(): Promise<image.PixelMap | undefined> {
    if (this.screenshotPixel) {
      return this.screenshotPixel;
    }
    const screenshotOptions: ScreenshotOptionsImpl = {
      rotation: 0,
      displayId: SCBSceneSessionManager.getInstance().mainScreenId,
      isCaptureFullOfScreen: true
    };
    log.showInfo('screeenshot start');
    this.screenshotPixel = new Promise<image.PixelMap | undefined>(resolve => {
      Trace.start(`${TAG}_screenshot`);
      screenshot.save(screenshotOptions).then(pixel => {
        Trace.end(`${TAG}_screenshot`);
        log.showInfo('screeenshot done');
        resolve(pixel);
      }).catch((err: BusinessError) => {
        log.showWarn(`screeenshot failed, err.code:${err?.code}`);
        let time: number = systemDateTime.getTime(false);
        HiDfxEventUtil.reportGetSnapshotFailed(err.message, time);
        resolve(undefined);
      })
    });
    return this.screenshotPixel;
  }

  release(): void {
    this.screenshotPixel = undefined;
  }
}

const desktopSnapshot: DesktopSnapshot = new DesktopSnapshot();

class EnterpriseMultiSpaceRecent {
  private vmSnapshot: image.PixelMap | null = null;
  private eventNeedRegister: boolean = true;

  init(): void {
    log.showInfo(`recent init`);
    if (this.eventNeedRegister && MultiSpace.get().checkSpaceEnable()) {
      try {
        this.registerPrepareEvent();
        this.eventNeedRegister = false;
      } catch (err) {
        log.showWarn(`register event failed. err.code:${err?.code}, err.message:${err?.message}`);
        this.eventNeedRegister = true;
      }
    }
  }

  async getVmSnapshot(): Promise<image.PixelMap | null> {
    try {
      if (this.vmSnapshot) {
        return this.vmSnapshot;
      }
      const vmSession = DesktopSwitchController.getInstance().getVmSceneContainerSession();
      if (!vmSession) {
        log.showWarn('vm session is null');
        return null;
      }
      const persistentId = vmSession.getPersistentId();
      log.showInfo('vm imagePixelMap snapshot start');
      const result: image.PixelMap = await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, 1);
      if (result) {
        PixelMapUtil.addName(result, ENTERPRISE_VM_SNAPSHOT_PIXEL_MAP_NAME);
        this.vmSnapshot = result;
        log.showInfo('vm imagePixelMap snapshot success');
        return this.vmSnapshot;
      }
      log.showWarn('vm imagePixelMap is null');
      return null;
    } catch (err) {
      log.showError(`getVmSnapshot failed, ${err?.code} ${err?.message}`);
      return null;
    }
  }

  releaseVmSnapshot(): void {
    log.showInfo('releaseVmSnapshot');
    this.vmSnapshot?.release((err: BusinessError) => {
      if (err) {
        log.showError(`releasePixelMap error: ${err.code} ${err.message}`);
      } else {
        log.showInfo('Succeeded in releasing vmSnapshot');
        this.vmSnapshot = null;
      }
    });
  }

  private readonly EVENT_WIN_TAB: string = 'usual.event.WIN_TAB';
  private readonly EVENT_ALT_TAB: string = 'usual.event.ALT_TAB';

  private registerPrepareEvent() {
    inputMonitor.on('threeFingersSwipe', (gesture: ThreeFingersSwipe) => {
      const isForeground = accountModel.getForegroundUserId() === accountModel.getCurrentUserId();
      const isCurrentVmDesktop = DesktopSwitchController.getInstance().isVmDesktop();
      if (isForeground && gesture.type === ActionType.BEGIN && !isCurrentVmDesktop) {
        this.takeScreenshot('threeFingersSwipeBegin');
      }
    });

    localEventManager.registerEventListener({
      onReceiveEvent: (event: string): void => {
        const isForeground = accountModel.getForegroundUserId() === accountModel.getCurrentUserId();
        const isCurrentVmDesktop = DesktopSwitchController.getInstance().isVmDesktop();
        if (isForeground && !isCurrentVmDesktop) {
          this.takeScreenshot(event)
        }
      }
    }, [this.EVENT_ALT_TAB, this.EVENT_WIN_TAB]);
  }

  getSpaceDesktops(): Array<Space> {
    const allUsers: IUserData[] | undefined = AppStorage.get('userList');
    if (!allUsers) {
      log.showWarn('get all spaces failed');
      return [];
    }
    const spaces = allUsers.map(user => {
      const space: Space = {
        id: user.userId,
        name: user.userName,
        type: user.userId === Space.ENTERPRISE_ID ? SpaceType.Enterprise : SpaceType.Personal,
        isCurrent: user.userId === accountModel.getCurrentUserId(),
        hasVm: false,
      };
      space.hasVm = space.isCurrent && DesktopSwitchController.getInstance().hasVmAbility();
      log.showInfo(`id: ${space.id}, name:${space.name}, type:${space.type}, isCurrent:${space.isCurrent}, hasVM:${space.hasVm}`)
      return space;
    })
    return spaces;
  }

  getCurrentSnapshot(): Promise<image.PixelMap | undefined> {
    const promise = desktopSnapshot.take();
    desktopSnapshot.release();
    return promise;
  }

  private takeScreenshot(reason: string) {
    log.showInfo(`takeScreenshot, reason:${reason}`);
    desktopSnapshot.take();
  }
}

export const enterpriseRecentEvent = new EnterpriseMultiSpaceRecent();

@Component
struct PreviewCardView {
  @Link screenProperty: SCBScreenProperty;
  @State backImg: Resource | image.PixelMap | undefined | null = undefined;
  @State vmSnapshot: image.PixelMap | null = null;
  @State spaceIcon: Resource | undefined | null = undefined;
  screenWidth: number = 0;
  imgWidth: number = 0;
  blankWidthVp: number = 0;
  @State imgHeight: number = 0;
  @State title: ResourceStr = '';
  name: Resource | string = '';
  @ObjectLink item: Space;
  isVm: boolean = false;
  private isFocused: boolean = false;
  @State isHover: boolean = false;
  onClickCurrent: (onAnimationFinish?: () => void) => void = () => {};
  @Prop isDarkMode: boolean = false;
  basePlateColor: string = '';
  private showScreenHeight: number = 0;

  private myid(): string {
    return `EnterpriseSpaceRecentView_${this.item.type}_${this.item.id}_${this.isVm ? 'vm' :
      'desktop'}`;
  }

  private initshowScreenHeight() {
    this.showScreenHeight = px2vp(this.screenProperty.height);
  }

  aboutToAppear(): void {
    this.initshowScreenHeight();
    this.isFocused = this.item.isCurrent && !this.isVm
    this.screenWidth = px2vp(this.screenProperty.width);
    this.imgWidth = this.screenWidth * 0.103;
    this.imgHeight = this.showScreenHeight * 0.103;
    if (this.item.isCurrent && !this.isVm) {
      enterpriseRecentEvent.getCurrentSnapshot()?.then(img => {
        this.backImg = img;
        this.spaceIcon = undefined;
      })
    } else if (this.isVm) {
      enterpriseRecentEvent.getVmSnapshot().then((img) => {
        this.vmSnapshot = img;
        this.spaceIcon = undefined;
      });
    } else {
      this.loadOtherSpaceIcon();
    }
    this.basePlateColor =
      GlobalContext.getContext().config.colorMode === 0 ? 'rgba(255, 255, 255, 0.3)' : 'rgba(0, 0, 0, 0.1)';
  }

  private loadOtherSpaceIcon() {
    this.backImg = $r('app.media.multispace_recentpanel_background');
    if (this.item.type === SpaceType.Enterprise) {
      this.spaceIcon = $r('app.media.multispace_recentpanel_enterprise');
    } else {
      this.spaceIcon = $r('app.media.multispace_recentpanel_personal');
    }
  }

  private onMyClick() {
    if (!this.item.isCurrent) {
      log.showInfo('recent click to other space');
      MultiSpaceSwitchOneGoCtrl.get().handle(SwipeGestureDirection.LEFT, SwitchEnterpriseMultiSpaceType.RECENT_PANEL);
      return;
    }
    if (this.isVm) {
      log.showInfo('recent click to vm');
      this.onClickCurrent?.(() => {
        FourFingerSwipeController.getInstance().oneTimeLeftSwipeMotionSnapshot();
      });
    } else {
      log.showInfo('exit recent');
      this.onClickCurrent?.();
    }
  }

  aboutToDisappear() {
    this.spaceIcon = undefined;
    this.backImg = undefined;
    if (this.isVm) {
      enterpriseRecentEvent.releaseVmSnapshot();
      this.vmSnapshot = null;
    }
    desktopSnapshot.release();
  }

  @Builder
  InnerCardStyleWrap() {
    Row() {}
    .width('100%')
    .height('100%')
    .zIndex(9)
    .backgroundColor($r('sys.color.mask_fifth'))
    .border({
      width: 1,
      radius: $r('sys.float.corner_radius_level3'),
      color: this.isFocused ? Color.Transparent : $r('sys.color.icon_on_fourth')
    })
  }

  @Builder
  OuterCardStyleWrap() {
    Row() {}
    .width('100%')
    .height('100%')
    .zIndex(9)
    .border({
      width: this.isFocused ? 2 : 1,
      radius: $r('sys.float.corner_radius_level4'),
      color: this.isFocused ? $r('sys.color.multi_color_aux_02') :
        this.isHover ? $r('sys.color.icon_on_fourth') : Color.Transparent
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Row() {
        Text(this.title)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.isDarkMode ? $r('sys.color.font_on_primary') : undefined)
          .fontSize($r('app.float.common_font_size14'))
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .margin({ top: 4, bottom: 4, left: 2 })

      Stack() {
        this.OuterCardStyleWrap();
        Stack() {
          this.InnerCardStyleWrap();
          Image(this.isVm ? this.vmSnapshot : this.backImg).size({ width: '100%', height: '100%' })
            .objectFit(ImageFit.Fill)
            .borderRadius($r('sys.float.corner_radius_level2'))
            .draggable(false)
          if (this.spaceIcon) {
            Stack()
              .size({ width: '100%', height: '100%' })
              .borderRadius($r('sys.float.corner_radius_level2'))
              .backgroundColor('rgba(0,0,0,0.05)')
              .blur(8)
              .foregroundBlurStyle(BlurStyle.Thin,
                { colorMode: ThemeColorMode.LIGHT })
            Image(this.spaceIcon)
              .width('24%')
              .objectFit(ImageFit.Fill)
              .blur(0.2)
              .draggable(false)
              .id(this.myid())
              .clip(true)
              .opacity(0.8)
              .draggable(false)
          }
        }
        .margin(4)
        .borderRadius($r('sys.float.corner_radius_level3'))
        .clip(true)
      }
      .backgroundColor(this.isHover || this.isFocused ?
        $r('sys.color.comp_background_secondary') : Color.Transparent)
      .borderRadius($r('sys.float.corner_radius_level3'))
      .onClick(evt => {
        log.showInfo(`myid: ${this.myid()}`);
        this.onMyClick();
      })
      .onHover((hovered) => this.isHover = hovered)
      .clip(true)
      .flexBasis(1)
      .flexGrow(1)
      .flexShrink(1)
      .constraintSize({
        maxHeight: this.imgHeight
      })

      Row() {
        Text(this.name)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.isDarkMode ? $r('sys.color.font_on_primary') : undefined)
          .fontSize($r('app.float.common_font_size14'))
          .fontWeight(FontWeight.Regular)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: '100%' })
          .maxLines(1)
      }
      .margin({ top: 4, bottom: 4, left: 2 })
    }
    .width(this.screenWidth * 0.103)
  }
}

@Component
struct SpaceView {
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink item: Space;
  screenWidth: number = 0;
  title: Resource | string = '';
  onClickCurrent: (onAnimationFinish?: () => void) => void = () => {};
  @Prop isDarkMode: boolean = false;
  private blankWidthVp: number = 15;

  aboutToAppear() {
    this.screenWidth = px2vp(this.screenProperty.width);
    this.blankWidthVp = this.screenWidth * 0.02;
    this.title = this.item.type === SpaceType.Enterprise ? $r('app.string.multispace_enterprise') :
    $r('app.string.multispace_personal');
  }

  @Builder
  buildSpaceViewTitle() {
    Row() {
      Blank(this.blankWidthVp + 10);
      Text(this.title)
        .fontFamily('HarmonyHeiTi')
        .fontColor(this.isDarkMode ? $r('sys.color.font_on_primary') : undefined)
        .fontSize($r('app.float.common_font_size14'))
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          top: 4,
          left: 2,
          right: 2,
          bottom: 2
        })
    }
  }

  build() {
    Column() {
      Row() {
        Blank(this.blankWidthVp);
        PreviewCardView({
          screenProperty: this.screenProperty,
          title: this.title,
          blankWidthVp: this.blankWidthVp,
          item: this.item,
          name: this.item.isCurrent ? $r('app.string.desktop') : this.item.name,
          onClickCurrent: this.onClickCurrent,
          isDarkMode: this.isDarkMode
        });
        if (this.item.hasVm) {
          Blank(this.blankWidthVp);
          PreviewCardView({
            screenProperty: this.screenProperty,
            item: this.item,
            blankWidthVp: this.blankWidthVp,
            isVm: true,
            name: $r('app.string.windows_vm'),
            onClickCurrent: this.onClickCurrent,
            isDarkMode: this.isDarkMode
          });
        }
        Blank(this.blankWidthVp);
      }
    }
    .alignItems(HorizontalAlign.Start)
    .height('100%')
  }
}

@Component
export struct EnterpriseRecentPanel {
  @Link screenProperty: SCBScreenProperty;
  @State posY: number = 0;
  onClickCurrent: (onAnimationFinish?: () => void) => void = () => {};
  @Link enterpriseRecentHeight: number;
  @State isDarkMode: boolean = true;
  private screenH: number = 0;
  private screenW: number = 0;
  private showScreenHeight: number = 0;

  aboutToAppear() {
    this.screenH = px2vp(this.screenProperty.height);
    this.screenW = px2vp(this.screenProperty.width);
    this.posY = this.screenH;
    this.getUIContext()?.animateTo({
      duration: 400,
      curve: Curve.Friction
    }, () => {
      this.initSizeAndPosition();
    })
    // 0：深色、1：浅色、2：花色
    this.isDarkMode = DockBackgroundMgr.getInstance().getDockColorMode() !== 1;
    log.showInfo(`dock color mode: ${this.isDarkMode}`);
  }

  aboutToDisappear(): void {
  }

  public getDockHeight(screenId: number): number {
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    let viewType = mainScreenId === screenId ? ViewType.SMART_DOCK : ViewType.SMART_DOCK_EXT_SCREEN;
    return viewMgrPolicy.getViewController(viewType)?.getArea()?.height ?? 0;
  }

  private initSizeAndPosition() {
    this.enterpriseRecentHeight = this.screenH * 0.16;
    let screenId = this.screenProperty.screenId;
    let dockHeight = this.getDockHeight(screenId);
    this.posY = this.screenH - this.enterpriseRecentHeight - dockHeight;
  }

  private getBrightnessOptions(): BrightnessOptions {
    if (this.isDarkMode) {
      return FixedDockResource.dockBackgroundBrightnessDarkParam;
    } else {
      return FixedDockResource.dockBackgroundBrightnessLightParam;
    }
  }

  @Builder
  buildBasePlate() {
    Row()
    .width('100%')
    .height('100%')
    .margin({ top: 1 })
    .border({
      width: { top: 1 },
      color: '#26FFFFFF',
    })
    .backgroundColor(this.isDarkMode ? 'rgba(0, 0, 0, 0.1)' : 'rgba(240, 240, 240, 0.01)')
    .backgroundBrightnessInternal(this.getBrightnessOptions())
    .backgroundEffect({
      radius: 60,
      brightness: 1.1
    })
  }

  build() {
    Stack() {
      this.buildBasePlate()
      Row() {
        ForEach(enterpriseRecentEvent.getSpaceDesktops(), (item: Space, index: number) => {
          if (index > 0) {
            Divider()
              .vertical(true)
              .height('15%')
              .color(this.isDarkMode ? '#FFFFFF' : '#000000')
              .opacity(0.2)
              .strokeWidth(1)
          }
          SpaceView({
            screenProperty: this.screenProperty,
            item: item,
            onClickCurrent: this.onClickCurrent,
            isDarkMode: this.isDarkMode
          })
        }, (item: Space) => `EnterpriseRecentPanel_${item.id}`)
      }
      .size({ width: '100%', height: '100%' })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(this.enterpriseRecentHeight)
    .position({ y: this.posY })
  }
}