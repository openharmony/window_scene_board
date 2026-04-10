/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { display, screenshot } from '@kit.ArkUI';
import { systemDateTime } from '@kit.BasicServicesKit';
import osAccount from '@ohos.account.osAccount';
import animator, { AnimatorResult } from '@ohos.animator';
import common from '@ohos.app.ability.common';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { BusinessError } from '@ohos.base';
import Curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import pointer from '@ohos.multimodalInput.pointer';
import util from '@ohos.util';
import { AnimateToScheduleUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  GlobalContext,
  HiDfxEventUtil,
  ViewCallback,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
  WallpaperManager,
  WallpaperType,
} from '@ohos/frameworkwrapper';
import lottie, { AnimationItem } from '@ohos/lottie';
import accountModel from '../screenlock/refactor/AccountsModel';
import { OsAccountSwitchEventData } from '../screenlock/refactor/AccountsModel';
import { SCBSceneSessionManager, SCBScreenProperty, SCBPropertyChangeReason, SCBUnlockTransitionController, SCBScreenSessionManager} from '@ohos/windowscene';
import {
  addPersonalSpaceCtrl,
  MultiSpace,
  MultiSpaceSwipeCtrl,
  MultiSpaceSwitchAnimationCtrlInf,
  MultiSpaceSwitchOneGoCtrl,
  SpaceTypeKey,
} from '../../common/EnterpriseMultiSpaceController';
import { SwitchAccountAnimationParameter } from '../screenlock/pages/SwitchAccountAnimation';
import { SCBSpaceLoadingView } from './SCBSpaceLoadingView';

const TAG = 'SCBMultiSpaceSwitchView';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const BACKGROUND_BLUR: number = 99;
const BACKGROUND_BRIGHTNESS: number = 0.6;
const ANIMATION_DURATION_MS: number = 1500;
const LOADING_TIP_TEXT_SIZE = '20vp';

export class MultiSpaceSwitchAnimationCtrl implements MultiSpaceSwitchAnimationCtrlInf {
  private static instance: MultiSpaceSwitchAnimationCtrl;
  private backAnimator: AnimatorResult | undefined = undefined
  private offsetRate: number = 0;
  private viewCallback: SwitchViewCallback | undefined;
  private screenshotPixel: Promise<image.PixelMap | undefined> | undefined = undefined;

  static get(): MultiSpaceSwitchAnimationCtrl {
    if (!MultiSpaceSwitchAnimationCtrl.instance) {
      MultiSpaceSwitchAnimationCtrl.instance = new MultiSpaceSwitchAnimationCtrl();
    }
    return MultiSpaceSwitchAnimationCtrl.instance;
  }

  static setViewCallback(callback: SwitchViewCallback | undefined) {
    MultiSpaceSwitchAnimationCtrl.get().viewCallback = callback;
  }

  private constructor() {
    osAccount.getAccountManager().on('switching', (switchEventData: OsAccountSwitchEventData) => {
      log.showInfo(`monitorUserSwitching, from ${switchEventData.fromAccountId} to ${switchEventData.toAccountId}`);
      if (!this.canHandleSpaceSwitch(switchEventData)) {
        return;
      }
      const switchBack = !this.isSwitchOut(switchEventData);
      log.showInfo(`switchBack:${switchBack}`);
      if (switchBack) {
        this.viewCallback?.onSwitchBackEnter();
      }
    });
    osAccount.getAccountManager().on('switched', (switchEventData: OsAccountSwitchEventData) => {
      log.showInfo(`monitorUserSwitched, from ${switchEventData.fromAccountId} to ${switchEventData.toAccountId}`);
      if (!this.canHandleSpaceSwitch(switchEventData)) {
        return;
      }
      const switchOut = this.isSwitchOut(switchEventData);
      const isSpaceLoading: boolean = AppStorage.get<boolean>('needShowSpaceLoadingView') as boolean;
      log.showInfo(`switchOut:${switchOut} isSpaceLoading: ${isSpaceLoading}`);
      // 如果isSpaceLoading为true，说明是首次创建个人空间，不需要展示动效
      if (!isSpaceLoading) {
        if (switchOut) {
          // 账号子系统保留当前sceneboard进程 ANIMATION_DURATION_MS， 用于切换时初始化目标sceneboard
          // 所以当前sceneboard需要在收到切换事件后等待ANIMATION_DURATION_MS再执行动效切换
          setTimeout(() => {
            this.viewCallback?.showPrepareEnter();
          }, 2_000);
        }
      }
    });

    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP_SWITCHER_SPACES, {
      onHide: (): void => {
        log.showInfo('SCBMultiSpaceSwitchView onHide resetAllState');
        this.resetAllState();
      }
    });
  }

  private canHandleSpaceSwitch(evtData: OsAccountSwitchEventData): boolean {
    if (!MultiSpace.get().checkSpaceEnable()) {
      log.showInfo('not enableEnterpriseSpace');
      return false;
    }
    const isActivateUser = evtData.fromAccountId === -1 || evtData.fromAccountId === evtData.toAccountId;
    return !isActivateUser;
  }

  private isSwitchOut(evtData: OsAccountSwitchEventData) {
    return accountModel.getCurrentUserId() !== evtData.toAccountId;
  }

  private showView(img: image.PixelMap): void {
    log.showInfo('showView');
    this.viewCallback?.init(img);
    ViewManagerPolicy.showView(ViewType.DESKTOP_SWITCHER_SPACES);
  }

  async startWithScreenshot(): Promise<image.PixelMap | undefined> {
    if (this.screenshotPixel) {
      return this.screenshotPixel;
    }

    if (ViewManagerPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER_SPACES)) {
      return this.screenshotPixel;
    }
    log.showInfo('screenshot start');
    const isInScreenLock = ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
    if (isInScreenLock) {
      log.showInfo(`screenLock:${isInScreenLock},do not screenshot, use desktop wallpaper`);
      this.screenshotPixel = WallpaperManager.getInstance().getWallpaper(WallpaperType.DESKTOP, TAG);
    } else {
      this.screenshotPixel = this.takeScreenshot();
    }
    Promise.race([this.screenshotPixel]).then(img => {
      if (!img) {
        this.screenshotPixel = undefined;
      }
    });
    return this.screenshotPixel;
  }

  private takeScreenshot(): Promise<image.PixelMap | undefined> {
    const screenshotOptions: screenshot.ScreenshotOptions = {
      'rotation': 0,
      'displayId': SCBSceneSessionManager.getInstance().mainScreenId
    };
    return new Promise<image.PixelMap | undefined>(resolve => {
      Trace.start('MULTISPACE_SWITCHVIEW_SCREENSHOT_START');
      screenshot.save(screenshotOptions).then(pixel => {
        Trace.end('MULTISPACE_SWITCHVIEW_SCREENSHOT_START');
        log.showInfo('screenshot done');
        resolve(pixel);
      }).catch((err: BusinessError) => {
        log.showWarn(`screenshot failed, err.code:${err?.code}`);
        let time: number = systemDateTime.getTime(false);
        HiDfxEventUtil.reportGetSnapshotFailed(err.message, time);
        resolve(undefined);
      })
    });
  }

  /**
   * 动效随四指左右移动
   *
   * @param offset 负数向左，正数向右; -1.0向左移100%，1.0向右移100%；
   */
  move(offset: number): boolean {
    if (this.backAnimator) {
      log.showInfo('auto playing, can not start again');
      return false;
    }
    if (!ViewManagerPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER_SPACES)) {
      Promise.race([this.screenshotPixel, undefined]).then(img => {
        if (img) {
          this.showView(img);
        }
      })
      return ViewManagerPolicy.isViewShowing(ViewType.DESKTOP_SWITCHER_SPACES);
    }
    const spaceType = this.getNextSpacePreview(offset);

    this.viewCallback?.setSecondary(spaceType, offset < 0);
    this.offsetRate = offset;
    animateToImmediately({
      curve: Curves.responsiveSpringMotion(),
    }, () => {
      this.viewCallback?.onMove(offset);
    });
    return true;
  }

  /**
   * 撤销切换，恢复到动效起始状态
   *
   * @returns
   */
  async restore(): Promise<void> {
    log.showInfo('restore');
    if (this.backAnimator) {
      log.showInfo('restore: auto playing, can not restore again');
      return Promise.resolve();
    }
    await this.makeOnceForAll(this.offsetRate, 0);
    this.finish();
    return;
  }

  /**
   * 切换空间，到动效切换状态
   *
   * @returns
   */
  toSwitch(): Promise<void> {
    log.showInfo('finishWithComplete');
    if (this.backAnimator) {
      log.showInfo('toSwitch: auto playing, can not toSwitch again');
      return Promise.resolve();
    }
    const finalOffset = this.offsetRate < 0 ? Direction.ToLeft : Direction.ToRight;
    return this.makeOnceForAll(this.offsetRate, finalOffset)
  }

  public async doneInOneGo(img: image.PixelMap, direction: Direction, spaceType?: SpaceTypeKey): Promise<boolean> {
    if (this.backAnimator) {
      log.showInfo('doneInOneGo: auto playing, can not start again');
      return false;
    }

    this.showView(img);
    const type = spaceType || this.getNextSpacePreview(direction);
    this.viewCallback?.setSecondary(type, direction < 0);
    await this.makeOnceForAll(0, direction);
    return true;
  }

  toFinish(): void {
    this.finish();
  }

  private finish() {
    log.showInfo('all animation finished. hideView');
    ViewManagerPolicy.hideView(ViewType.DESKTOP_SWITCHER_SPACES);
    this.resetAllState();
  }

  private async resetAllState() {
    log.showInfo('resetAllState begin');
    performanceMonitor.end('SWITCH_DESKTOP');
    this.viewCallback?.onFinish();
    this.backAnimator = undefined;
    await this.releasePixelMap(this.screenshotPixel);
    this.screenshotPixel = undefined;
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
    log.showInfo('resetAllState done');
  }

  private async releasePixelMap(screenshotPixel?: Promise<image.PixelMap | undefined>): Promise<void> {
    const pixelMap: image.PixelMap | undefined = await screenshotPixel;
    pixelMap?.release((err: BusinessError) => {
      if (err) {
        log.showError(`releasePixelMap error: ${err.message}`);
      }
    });
  }

  private getNextSpacePreview(offset: number): SpaceTypeKey {
    // 手势移动方向，和下一个空间出现方向相反。如向左滑动，下一个空间从右侧出现；故取反

    return MultiSpace.get().getSpace(offset);
  }

  private async makeOnceForAll(src: number, dst: number): Promise<void> {
    log.showInfo(`makeOnceForAll from=${src}, dst=${dst}, backAnimator=${this.backAnimator}`);
    if (this.backAnimator) {
      return;
    }
    const distance = Math.abs(dst - src);

    this.backAnimator = animator.create({
      duration: distance * ANIMATION_DURATION_MS,
      easing: 'cubic-bezier(0.5,0,0.6,1)',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: src,
      end: dst
    })
    this.backAnimator.onFrame = (value: number) => {
      this.viewCallback?.onMove(value);
    }
    const result: Promise<void> = new Promise((resolve) => {
      if (this.backAnimator) {
        this.backAnimator.onFinish = () => {
          log.showInfo('makeOnceForAll finish play');
          resolve();
        }
      }
    });
    log.showInfo('makeOnceForAll start play');
    this.backAnimator?.play();
    await result;
    return result;
  }
}

enum SpaceSwitchViewType {
  None, SwitchLeave, PrepareBack, SwitchBack, CreateLeave
}

interface SwitchViewCallback {
  init(currentSnapshotImg: image.PixelMap): void;

  setSecondary(type: SpaceTypeKey, toLeft: boolean): void;

  onMove(offset: number): void;

  onFinish(): void;

  showPrepareEnter(): void;

  onSwitchBackEnter(): void;
}

enum Direction {
  ToLeft = -1,
  ToRight = 1
}

class SegmentAttrs {
  public percent0to8: number = 0;
  public percent8to20: number = 0;
  public percent20to100: number = 0;
  public percent70to100: number = 0;
  public percent90to100: number = 0;
  public direction: number = Direction.ToLeft;
  public atFull: boolean = false;

  update(offset: number): void {
    if (Math.abs(offset) > Number.EPSILON) {
      this.direction = offset < 0 ? Direction.ToLeft : Direction.ToRight;
    }
    const absOffset = Math.abs(offset);
    // 此处数字表示移动比例，
    this.percent0to8 = Math.min(1, absOffset / 0.16);
    this.percent8to20 = Math.min(1, Math.max(0, absOffset - 0.16) / 0.14);
    this.percent20to100 = Math.min(1, Math.max(0, absOffset - 0.3) / 0.7);
    this.percent70to100 = Math.min(1, Math.max(0, absOffset - 0.7) / 0.3);
    this.percent90to100 = Math.min(1, Math.max(0, absOffset - 0.9) / 0.1);
    this.atFull = Math.abs(1 - absOffset) < Number.EPSILON;
  }
}

class SegmentDelta {
  public readonly base: number = 0;
  private delta0to8: number = 0;
  private delta8to20: number = 0;
  private delta20to100: number = 0;
  private delta70to100: number = 0;

  constructor(base: number, delta0to8: number, delta8to20: number, delta20to100: number, delta70to100: number) {
    this.base = base;
    this.delta0to8 = delta0to8;
    this.delta8to20 = delta8to20;
    this.delta20to100 = delta20to100;
    this.delta70to100 = delta70to100;
  }

  totalDelta(offset: SegmentAttrs): number {
    return this.delta0to8 * offset.percent0to8 + this.delta8to20 * offset.percent8to20 +
      this.delta20to100 * offset.percent20to100 + this.delta70to100 * offset.percent70to100;
  }

  update(offset: SegmentAttrs): number {
    return this.base + this.totalDelta(offset);
  }
}

@Component
export struct SpaceSwitchSnapshotView {
  @Prop screenWidthVp: number;
  @Prop visible: boolean = false;
  @Link snapshotPic: image.PixelMap | null;
  @Prop @Watch('onRealOffsetChangeCenter') mySegmentAttr: SegmentAttrs;
  @State myRadius: number = 0;
  @State myShadowRadius: number = 0;
  @State myOpacity: number = 1;
  @State myTranslateX: number = 0;
  @State myScale: ScaleOptions = {};
  @State myRotate: RotateOptions = { angle: 0 };
  @State myRotateAngle: number = 0;
  // UX 变化参数表
  private backTranslateTbl: SegmentDelta = new SegmentDelta(0, 0.03, 0.03, 0.76, 0);
  private backScaleTbl: SegmentDelta = new SegmentDelta(1, -0.1, -0.1, -0.2, 0);
  private backRotateAngleTbl: SegmentDelta = new SegmentDelta(0, 2, 3, 20, 0);
  private backRadiusTbl: SegmentDelta = new SegmentDelta(0, 25, 0, 0, 0);
  private backOpacityTbl: SegmentDelta = new SegmentDelta(1, 0, 0, 0, -1);
  private backShadowRadius: SegmentDelta = new SegmentDelta(0, 50, 0, 0, 0);

  onRealOffsetChangeCenter() {
    this.myTranslateX = this.mySegmentAttr.direction * this.backTranslateTbl.update(this.mySegmentAttr) * this
      .screenWidthVp;

    const scale = this.backScaleTbl.update(this.mySegmentAttr);
    this.myScale.x = scale;
    this.myScale.y = scale;

    // update rotate
    this.myRotateAngle = this.mySegmentAttr.direction * this.backRotateAngleTbl.update(this.mySegmentAttr);
    // update 边框radius圆角
    this.myRadius = this.backRadiusTbl.update(this.mySegmentAttr);
    // update 透明度
    this.myOpacity = this.backOpacityTbl.update(this.mySegmentAttr);
    // 阴影尺寸
    this.myShadowRadius = this.backShadowRadius.update(this.mySegmentAttr);
  }

  build() {
    Image(this.snapshotPic)
      .syncLoad(true)
      .clip(true)
      .size({ width: '100%', height: '100%' })
      .shadow({ radius: this.myShadowRadius, color: Color.White })
      .borderRadius(this.myRadius)
      .outline({ width: 1.5, color: 0x32FFFFFF, radius: this.myRadius })
      .opacity(this.myOpacity)
      .translate({ x: this.myTranslateX })
      .scale(this.myScale)
      .rotate({ y: 1, angle: this.myRotateAngle })
      .visibility(this.visible ? Visibility.Visible : Visibility.Hidden);
  }
}

enum ParticlesState {
  None, Load, Play
}

export class Particles {
  private setting: RenderingContextSettings = new RenderingContextSettings(true);
  public readonly context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
  private lottiePath: string = '';
  private lottieName: string = '';
  private lottieItem?: AnimationItem;
  private lottieStrObj?: object;
  private state: ParticlesState = ParticlesState.None;

  constructor(name: string, path: string) {
    this.lottieName = `multispace_${name}`;
    this.lottiePath = path;
  }

  public load() {
    if (this.state !== ParticlesState.None) {
      return;
    }
    log.showDebug(`Particles load:${this.lottieName}`);
    this.state = ParticlesState.Load;
    if (this.lottieStrObj) {
      log.showDebug(`Particles load:${this.lottieName} already loaded.`);
      return;
    }

    let resourceManager = GlobalContext.getContext().resourceManager;
    resourceManager.getRawFileContent(this.lottiePath)
      .then((uint8Data: Uint8Array) => {
        const decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        const lottieStr = decoder.decodeWithStream(uint8Data, { stream: false });
        try {
          this.lottieStrObj = JSON.parse(lottieStr);
        } catch (err) {
          log.showError(`Particles failed. err: ${err?.message}`);
        }
        log.showInfo(`Particles loadAnimation: ${this.lottieName}`);
      })
      .catch((err: BusinessError) => {
        log.showWarn(`Particles failed. err.code=${err.code}`);
      });
  }

  public play() {
    log.showDebug(`Particles play:${this.lottieName}`);
    if (this.state !== ParticlesState.Load) {
      return;
    }
    this.state = ParticlesState.Play;
    this.lottieItem = lottie.loadAnimation({
      container: this.context,
      // 目前只支持canvas模式
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      name: this.lottieName,
      frameRate: 60,
      animationData: this.lottieStrObj,
      packageName: 'SCBMultiSpaceSwitchView'
    })
  }

  public stop() {
    log.showDebug(`Particles stop:${this.lottieName}`);
    if (this.state !== ParticlesState.Play) {
      log.showDebug(`Particles stop:${this.lottieName}, not playing, do nothing`);
      return;
    }
    this.lottieItem?.stop();
    this.lottieItem?.destroy();
    this.lottieItem = undefined;
    this.state = ParticlesState.None;
  }
}

@Component
export struct SpaceSwitchPreview {
  screenWidthVp: number = 0;
  @Link desktopWallpaper: image.PixelMap | null;
  @Prop @Watch('onSpaceTypeChange') spaceType: SpaceTypeKey = SpaceTypeKey.None;
  @Prop @Watch('onRealOffsetChangeCenter') mySegmentAttr: SegmentAttrs;
  @Prop visible: boolean = false;
  @Prop targetDirection: number;
  @Prop @Watch('onSpaceLoading') onLoading: boolean;
  // 背景图参数
  @State backRadius: number = 0;
  @State backShadowRadius: number = 0;
  @State backOpacity: number = 0;
  @State backTranslateX: number = 0;
  @State myScale: ScaleOptions = {};
  @State backRotateAngle: number = 0;
  // UX 变化参数表
  private backTranslateTbl: SegmentDelta = new SegmentDelta(0.92, 0, -0.08, -0.84, 0);
  private backScaleTbl: SegmentDelta = new SegmentDelta(0.75, 0, -0.05, 0.1, 0);
  private backRotateAngleTbl: SegmentDelta = new SegmentDelta(25, 0, 0, -25, 0);
  private backRadiusTbl: SegmentDelta = new SegmentDelta(25, 0, 0, 0, 0);
  private backVisible: boolean = false;
  private backShadowRadiusTbl: SegmentDelta = new SegmentDelta(0, 0, 25, 25, 0);
  // space icon
  @State spaceIconVisible: boolean = false;
  @State spaceIconTranslateX: number = 0;
  @State spaceIconScale: ScaleOptions = {};
  @State spaceIconBackScale: ScaleOptions = {};
  @State spaceIconRotateAngle: number = 0;
  @State spaceIconOpacity: number = 0;
  @State spaceLoadTxtOpacity: number = 0;
  private spaceIconTranslateTbl: SegmentDelta = new SegmentDelta(0.55, -0.0975, -0.0175, -0.435, 0);
  private spaceIconScaleTbl: SegmentDelta = new SegmentDelta(0.85, 0, 0.15, 0, 0);
  private spaceIconRotateTbl: SegmentDelta = new SegmentDelta(20, 0, -10, -10, 0);
  private spaceIconOpacityTbl: SegmentDelta = new SegmentDelta(0, 0, 1, 0, 0);
  @State spaceTitle: Resource | null = null;
  @State spaceIcon: Resource | null = null;
  // 粒子效果
  private midParticles: Particles = new Particles('loading_lottie', 'multispace_loading_lottie.json');
  @State midParticlesVisible: Visibility = Visibility.Hidden;
  @State loadingOpacity: number = 0;
  // SCB2 Animation
  @State switchIconOpacity: number = 1;
  @State backgroundBlur: number = 50;
  @State switchBorderWidth: number = 1;
  @Prop @Watch('onShowViewTypeUpdate') showViewType: SpaceSwitchViewType;
  @State wallpaperOpacity: number = 1;
  @State spaceLoadBlue: number = 10;
  @Link doubleStarOpacity: number;
  private firstMove: boolean = true;

  onSpaceTypeChange() {
    if (this.spaceType === SpaceTypeKey.Enterprise) {
      this.spaceIcon = $r('app.media.multispace_enterprise');
      this.spaceTitle = $r('app.string.multispace_enterprise');
    } else if (this.spaceType === SpaceTypeKey.Personal) {
      this.spaceIcon = $r('app.media.multispace_personal');
      this.spaceTitle = $r('app.string.multispace_personal');
    } else {
      log.showInfo('onSpaceTypeChange SpaceTypeKey.None');
      return;
    }
  }

  onShowViewTypeUpdate() {
    log.showInfo(`this.showViewType:${this.showViewType}`);
    if (this.showViewType === SpaceSwitchViewType.SwitchBack) {
      this.spaceType = MultiSpace.get().getCurrentSpaceType();
      this.switchEnterAnimation();
    } else {
      this.wallpaperOpacity = 0;
      this.initialState();
      this.onSpaceTypeChange();
    }
    if (this.showViewType === SpaceSwitchViewType.PrepareBack) {
      animateTo({ duration: 2_000 }, () => {
        this.spaceIconOpacity = 0;
        this.spaceLoadTxtOpacity = 0;
      })
    }
  }

  aboutToAppear(): void {
    this.onSpaceTypeChange();
    this.firstMove = true;
    if (this.showViewType === SpaceSwitchViewType.SwitchBack) {
      this.onShowViewTypeUpdate();
    }
  }

  private initialState(): void {
    log.info('SpaceSwitchEnterAnimation Set initial state');
    this.spaceIconVisible = true;
    this.backVisible = true;
    this.myScale = SwitchAccountAnimationParameter.spaceSwitchScaleBegin;
    this.spaceIconOpacity = SwitchAccountAnimationParameter.spaceSwitchIconOpacityBegin;
    this.spaceLoadTxtOpacity = SwitchAccountAnimationParameter.spaceSwitchIconOpacityBegin;
    this.backOpacity = SwitchAccountAnimationParameter.spaceSwitchOpacityBegin;
    this.backRadius = SwitchAccountAnimationParameter.spaceSwitchRadiusBegin;
    this.backShadowRadius = SwitchAccountAnimationParameter.spaceSwitchShadowRadiusBegin;
    this.spaceLoadTxtOpacity = SwitchAccountAnimationParameter.spaceSwitchSpaceLoadTxtOpacityBegin;
    this.wallpaperOpacity = SwitchAccountAnimationParameter.spaceLoadOpacityBegin;
  }

  private switchEnterAnimation() {
    log.info('SpaceSwitchEnterAnimation start');
    animateTo({
      delay: SwitchAccountAnimationParameter.delay,
      duration: 250,
      curve: Curve.Friction,
      onFinish: () => {
        this.switchEnterAnimationContent();
      }
    }, () => {
      this.spaceIconScale = SwitchAccountAnimationParameter.spaceSwitchIconScaleBegin;
      this.spaceIconBackScale = SwitchAccountAnimationParameter.spaceSwitchIconScaleBegin;
      this.spaceIconOpacity = SwitchAccountAnimationParameter.spaceSwitchIconOpacityEnd;
      this.wallpaperOpacity = SwitchAccountAnimationParameter.spaceLoadOpacityEnd;
      this.spaceLoadTxtOpacity = SwitchAccountAnimationParameter.spaceSwitchIconOpacityEnd;
    })
  }

  private switchEnterAnimationContent() {
    animateTo({
      delay: SwitchAccountAnimationParameter.spaceSwitchScaleTime,
      duration: 700 * SwitchAccountAnimationParameter.dynamicEffectRatio,
      curve: Curve.FastOutSlowIn,
      onFinish: () => {
        Trace.end('SWITCHACCOUNTANIMATION_DESKTOP_EAGERLY');
        log.info('SpaceSwitchEnterAnimation finish');
      }
    }, () => {
      this.myScale = SwitchAccountAnimationParameter.spaceSwitchScaleEnd;
      this.wallpaperOpacity = SwitchAccountAnimationParameter.spaceLoadOpacityBegin;
      this.backgroundBlur = SwitchAccountAnimationParameter.spaceSwitchSpaceBackgroundBlurEnd;
      this.doubleStarOpacity = 0;
    })
    animateTo({
      delay: SwitchAccountAnimationParameter.spaceSwitchRadiusTime,
      duration: 300 * SwitchAccountAnimationParameter.dynamicEffectRatio,
      curve: Curve.Sharp
    }, () => {
      this.backRadius = SwitchAccountAnimationParameter.spaceSwitchBackRadiusEnd;
      this.backShadowRadius = SwitchAccountAnimationParameter.spaceSwitchBackShadowRadiusEnd;
    })
  }

  // 中心轴
  onRealOffsetChangeCenter() {
    if (this.showViewType === SpaceSwitchViewType.SwitchBack) {
      return;
    }
    this.updateBackAttr();
    this.updateSpaceIconAttr();
    this.midParticles.load();
  }

  private updateBackAttr() {
    this.backTranslateX = -this.mySegmentAttr.direction * this.backTranslateTbl.update(this.mySegmentAttr) * this
      .screenWidthVp;
    // update scale
    const scale = this.backScaleTbl.update(this.mySegmentAttr);
    this.myScale.x = scale;
    this.myScale.y = scale;

    // update rotate
    this.backRotateAngle = -this.mySegmentAttr.direction * this.backRotateAngleTbl.update(this.mySegmentAttr);
    // update 边框radius圆角
    this.backRadius = this.backRadiusTbl.update(this.mySegmentAttr);
    // 阴影尺寸
    this.backShadowRadius = this.backShadowRadiusTbl.update(this.mySegmentAttr);
    this.backVisible = this.mySegmentAttr.percent8to20 > 0;
  }

  private updateSpaceIconAttr() {
    this.spaceIconTranslateX = -this.mySegmentAttr.direction * this.spaceIconTranslateTbl.update(this.mySegmentAttr) *
    this.screenWidthVp;

    const iconScale = this.spaceIconScaleTbl.update(this.mySegmentAttr);
    this.spaceIconScale.x = iconScale;
    this.spaceIconScale.y = iconScale;
    this.spaceIconBackScale.x = iconScale;
    this.spaceIconBackScale.y = iconScale;

    this.spaceIconRotateAngle = -this.mySegmentAttr.direction * this.spaceIconRotateTbl.update(this.mySegmentAttr);
    this.spaceIconOpacity = this.spaceIconOpacityTbl.update(this.mySegmentAttr);
    this.spaceIconVisible = this.mySegmentAttr.percent0to8 >= Number.EPSILON && !this.firstMove;
    this.firstMove = false;

    this.spaceLoadTxtOpacity = this.mySegmentAttr.percent90to100;
  }

  onSpaceLoading() {
    if (this.onLoading) {
      this.midParticles.play();
      this.midParticlesVisible = Visibility.Visible;
      this.spaceLoadingAnimation();
    } else {
      this.midParticles.stop();
      this.midParticlesVisible = Visibility.Hidden;
    }
  }

  private async spaceLoadingAnimation() {
    const baseScale = this.spaceIconScaleTbl.update(this.mySegmentAttr);
    let scale = baseScale;
    let scaleChange = 0.03;
    while (this.onLoading) {
      await this.spaceIconScaleAnimation(scale);
      scale = baseScale + scaleChange;
      scaleChange = -scaleChange;
    }
  }

  spaceIconScaleAnimation(scale: number): Promise<void> {
    return new Promise(resolve => {
      animateToImmediately({
        duration: 1000,
        curve: Curve.FastOutSlowIn,
        onFinish: () => resolve(),
      }, () => {
        this.spaceIconBackScale.x = scale;
        this.spaceIconBackScale.y = scale;
      })
    })
  }

  @Builder
  buildWallpaper() {
    Image(this.desktopWallpaper)
      .size({ width: '100%', height: '100%' })
      .borderRadius(this.backRadius)
      .clip(true)
      .blur(this.backgroundBlur)
      .translate({ x: this.backTranslateX })
      .scale(this.myScale)
      .opacity(this.wallpaperOpacity)
  }

  @Builder
  buildBackground() {
    Rect()
      .size({ width: '100%', height: '100%' })
      .borderRadius(this.backRadius)
      .clip(true)
      .fill(Color.White)
      .fillOpacity(0.05)
      .blur(this.backgroundBlur)
      .stroke(0x32FFFFFF)
      .strokeWidth(1.5)
      .strokeOpacity(0.5)
      .shadow({ radius: this.backShadowRadius, color: 0x32FFFFFF })
      .translate({ x: this.backTranslateX })
      .scale(this.myScale)
      .rotate({ y: 1, angle: this.backRotateAngle })
      .visibility(this.backVisible ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  buildMiddleParticles() {
    Canvas(this.midParticles.context).size({ width: 200, height: 200 }).visibility(this.midParticlesVisible)
      .scale({ x: 1.2, y: 1.2 })
      .onDisAppear(() => {
        this.midParticles.stop();
        this.midParticlesVisible = Visibility.Hidden;
      })
  }

  @Builder
  buildSpaceIcon() {
    Stack() {
      Image($r('app.media.multispace_back')).size({ width: 200, height: 200 })
        .syncLoad(true).draggable(false).scale(this.spaceIconBackScale);
      Image(this.spaceIcon).size({ width: 120, height: 120 }).syncLoad(true).draggable(false)
        .scale(this.spaceIconScale)
    }
    .rotate({ y: 1, angle: this.spaceIconRotateAngle })
    .visibility(this.spaceIconVisible ? Visibility.Visible : Visibility.Hidden)
    .opacity(this.spaceIconOpacity)
  }

  @Builder
  buildSpaceLoadingText() {
    Column({ space: 10 }) {
      Text(this.spaceTitle)
        .fontColor('#FFFFFF').fontWeight(FontWeight.Medium).fontSize(LOADING_TIP_TEXT_SIZE)
        .opacity(1);
      Text($r('app.string.multispace_isloading'))
        .fontColor('#FFFFFF').fontWeight(FontWeight.Regular).fontSize(LOADING_TIP_TEXT_SIZE)
        .opacity(0.4);
    }.opacity(this.spaceLoadTxtOpacity).translate({ y: -10 })
  }

  build() {
    Stack() {
      if (this.showViewType !== SpaceSwitchViewType.SwitchBack) {
        this.buildBackground();
      }
      if (this.showViewType === SpaceSwitchViewType.PrepareBack ||
        this.showViewType === SpaceSwitchViewType.SwitchBack) {
        this.buildWallpaper();
      }
      Column({ space: 0 }) {
        Stack() {
          this.buildMiddleParticles();
          this.buildSpaceIcon();
        }

        this.buildSpaceLoadingText();
      }.translate({ x: this.spaceIconTranslateX })
    }.size({ width: '100%', height: '100%' })
    .visibility(this.visible ? Visibility.Visible : Visibility.Hidden);
  }
}

@Component
export struct SCBMultiSpaceSwitchView {
  persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State screenWidth: number = 0;
  @State screenHeight: number = 0;
  private desktopSwitchCallback: ViewCallback = {
    onShow: (): void => {
      Trace.end('SWITCHACCOUNTANIMATION_FOUR_FINGER_TRIGGER');
      log.showInfo('SCBMultiSpaceSwitchView onShow');
      pointer.setPointerVisibleSync(false);
    },
    onHide: (): void => {
      log.showInfo('SCBMultiSpaceSwitchView onHide');
      pointer.setPointerVisibleSync(true);
    }
  };
  @State viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP_SWITCHER_SPACES);
  @State realOffset: number = 0;
  @State mySegmentAttr: SegmentAttrs = new SegmentAttrs();
  @StorageLink('desktopWallpaperChange') desktopWallpaper: image.PixelMap | null = null;
  @StorageLink('needShowSpaceLoadingView') @Watch('watchNeedShowSpaceLoading') needShowSpaceLoading: boolean = false;
  @StorageProp('mCurrentUserId') @Watch('watchCurrentUserId') mCurrentUserId: number = 0;
  @State doubleStar: Resource | null = null;
  @State snapshotPic: image.PixelMap | null = null;
  @State secondarySpaceType: SpaceTypeKey = SpaceTypeKey.None;
  @State currentSpaceType: SpaceTypeKey = SpaceTypeKey.None;
  @State mainVisible: boolean = false;
  private firstMove: boolean = true;
  @State secondaryVisible: boolean = false;
  @State welcomeAuraOpacity: number = 0;
  private welcomeAuraOpacityTbl: SegmentDelta = new SegmentDelta(0, 0.25, 0.25, 0, -0.5);
  @State onLoading: boolean = false;
  @State targetDirection: number = Direction.ToLeft;
  // double star
  @State doubleStarTranslateX: number = 0;
  @State doubleStarScale: ScaleOptions = {};
  @State doubleStarOpacity: number = 0;
  private doubleStarTranslateXTbl: SegmentDelta = new SegmentDelta(0.55, -0.0975, -0.0175, -0.435, 0);
  @State doubleStarVisible: Visibility = Visibility.Hidden;
  @State maskingSwitch: boolean = false;
  @State wallpaperBackground: number = 1;
  @State switchToDesktop: boolean = false;
  @State maskingSwitchAnimation: boolean = false;

  private unLockTransitionController: SCBUnlockTransitionController = {
    name: '',
    onLock: () => {
    },
    onUnlock: () => {
      log.info('onUnlock');
      this.needShowSpaceLoading = false;
    }
  };
  @State showViewType: SpaceSwitchViewType = SpaceSwitchViewType.None;

  aboutToAppear() {
    log.info('aboutToAppear');
    viewMgrPolicy.registerViewController(ViewType.DESKTOP_SWITCHER_SPACES, this.viewController);
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP_SWITCHER_SPACES, this.desktopSwitchCallback);

    this.doubleStar = $r('app.media.multispace_doublestar');
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenStatusChange, this.screenProp?.screenId);
    this.viewController.updateId(this.persistentId);
    this.screenWidth = px2vp(this.screenProp!.width);
    this.screenHeight = px2vp(this.screenProp!.height);
    MultiSpaceSwitchAnimationCtrl.setViewCallback(this);

    MultiSpaceSwipeCtrl.get().setAnimationCtrl(MultiSpaceSwitchAnimationCtrl.get());
    MultiSpaceSwitchOneGoCtrl.get().setAnimationCtrl(MultiSpaceSwitchAnimationCtrl.get());
    this.registerTransparentDetection();
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  watchNeedShowSpaceLoading(): void {
    log.info(`watchNeedShowSpaceLoading needShowSpaceLoading ${this.needShowSpaceLoading}`);
  }

  watchCurrentUserId(): void {
    log.info(`watchCurrentUserId mCurrentUserId ${this.mCurrentUserId}`);
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    session?.registerContextTransparentCallback(() => {
      log.showError('window is transparency!!');
    })
  }

  async onSwitchBackEnter(): Promise<void> {
    log.showInfo(`onSwitchBackEnter. currentSpace:${accountModel.getCurrentUserId()}`);
    this.showViewType = SpaceSwitchViewType.SwitchBack;
    setTimeout((): void => {
      ViewManagerPolicy.hideView(ViewType.DESKTOP_SWITCHER_SPACES);
    }, 2_000);
  }

  showPrepareEnter(): void {
    log.showInfo('onSwitchOut showPrepareEnter');
    this.showViewType = SpaceSwitchViewType.PrepareBack;
  }

  aboutToDisappear() {
    log.info('aboutToDisappear');
    this.secondaryVisible = false;
    this.mainVisible = false;
    this.doubleStar = null;
    this.desktopWallpaper = null;

    viewMgrPolicy.unregisterViewController(ViewType.DESKTOP_SWITCHER_SPACES);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP_SWITCHER_SPACES, this.desktopSwitchCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenStatusChange);
    MultiSpaceSwitchAnimationCtrl.setViewCallback(undefined);
    MultiSpaceSwipeCtrl.get().setAnimationCtrl(null);
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
  }

  private screenStatusChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`receive screenStatusChange, new screen width: ${screenProperty?.width}` +
      `, screen height: ${screenProperty?.height}, screenId: ${screenProperty?.screenId}` +
      `, rsId: ${screenProperty?.rsId}, reason: ${reason}`);
    this.screenProp = screenProperty;
    this.screenWidth = screenProperty ? px2vp(screenProperty?.width) : this.screenWidth;
    this.screenHeight = screenProperty ? px2vp(screenProperty?.height) : this.screenHeight;
    this.viewController?.updateRect({
      left: 0,
      top: 0,
      width: this.screenWidth,
      height: this.screenHeight
    })
  };

  onMove(offset: number): void {
    this.realOffset = offset;
    this.mySegmentAttr.update(offset);
    this.welcomeAuraOpacity = this.welcomeAuraOpacityTbl.update(this.mySegmentAttr);
    const absOffset = Math.abs(offset);
    this.secondaryVisible = !this.firstMove;
    this.firstMove = !this.viewController.isShowing();
    this.mainVisible = Math.abs(1 - absOffset) > Number.EPSILON;
    this.onLoading = this.mySegmentAttr.atFull;

    this.updateDoubleStar();
  };

  onFinish(): void {
    log.showWarn('SCBMultiSpaceSwitchView onFinish');
    // 恢复到位移为0状态
    this.onMove(0);
    // 释放缓存的截图
    this.snapshotPic = null;
    this.firstMove = true;
    this.onLoading = false;
    this.secondarySpaceType = SpaceTypeKey.None;
    this.secondaryVisible = false;
  }

  init(currentSnapshotImg: image.PixelMap): void {
    log.showDebug('SCBMultiSpaceSwitchView init');
    if (this.snapshotPic) {
      log.showWarn('init already setImage, dont set again');
      return;
    }
    this.snapshotPic = currentSnapshotImg;
    this.realOffset = 0;
    this.mainVisible = true;
    this.secondaryVisible = false;
    this.showViewType = SpaceSwitchViewType.SwitchLeave;
    this.correctWidthHeightWithOrientation();
  };

  private correctWidthHeightWithOrientation() {
    log.showInfo(`is not supperfold machine`);
    return;
  }

  setSecondary(type: SpaceTypeKey, toLeft: boolean): void {
    log.showDebug(`SCBMultiSpaceSwitchView setSecondary=${type}, toLeft=${toLeft}`);
    this.secondarySpaceType = type;
    this.targetDirection = toLeft ? Direction.ToLeft : Direction.ToRight;
  };

  updateDoubleStar() {
    this.doubleStarTranslateX =
      -this.mySegmentAttr.direction * this.doubleStarTranslateXTbl.update(this.mySegmentAttr) *
      this.screenWidth;
    const absOffset = Math.abs(this.realOffset);
    const doubleStarBeginScale = 2.5;
    const doubleStarDeltaScale = 1.5;
    let scale = doubleStarBeginScale - absOffset * doubleStarDeltaScale;
    if (scale < 1) {
      scale = 1;
    }
    this.doubleStarScale.x = scale;
    this.doubleStarScale.y = scale;
    // 8%时开始显示，70%时完全不透明
    const offsetOfBegin = 0.08;
    const offsetDelta = 0.62;
    const rate = Math.min((absOffset - offsetOfBegin) / offsetDelta, 1);
    this.doubleStarOpacity = rate;
    this.doubleStarVisible = (this.mySegmentAttr.percent8to20 > 0) ? Visibility.Visible : Visibility.Hidden;
  }

  @Builder
  buildBackground() {
    Image(this.desktopWallpaper)
      .size({ width: '100%', height: '100%' })
      .backgroundImageSize(ImageSize.Cover)
      .blur(BACKGROUND_BLUR)
      .brightness(BACKGROUND_BRIGHTNESS)
      .draggable(false)
      .objectFit(ImageFit.Cover)
  }

  @Builder
  buildDoubleStar() {
    Image(this.doubleStar)
      .size({ width: '100%', height: '100%' })
      .backgroundImageSize(ImageSize.Cover)
      .draggable(false)
      .scale(this.doubleStarScale)
      .translate({ x: this.doubleStarTranslateX })
      .opacity(this.doubleStarOpacity)
      .visibility(this.doubleStarVisible)
      .objectFit(ImageFit.Cover)
  }

  @Builder
  buildWelcomeAura() {
    if (this.realOffset < 0) {
      this.buildWelcomeAuraRight();
    } else if (this.realOffset > 0) {
      this.buildWelcomeAuraLeft()
    }
  }

  @Builder
  buildWelcomeAuraRight() {
    Stack() {
      Stack()
        .size({ width: 100, height: 800 })
        .borderRadius({ topLeft: 100, bottomLeft: 100 })
        .shadow({ radius: 150, color: Color.White, offsetX: -100 })
      Stack()
        .size({ width: 100, height: 640 })
        .borderRadius({ topLeft: 100, bottomLeft: 100 })
        .shadow({ radius: 130, color: Color.White, offsetX: -100 })
      Shape() {
        Path().commands('M30 0 C30 0 0 200 30 500 L30 200 Z').fill(Color.White).strokeOpacity(0)
      }.shadow({
        radius: 8,
        color: Color.White,
        type: ShadowType.BLUR,
        offsetX: -130,
      })
    }
    .alignContent(Alignment.End)
    .useShadowBatching(true)
    .translate({ x: `${0.53 * this.screenWidth}` })
    .opacity(this.welcomeAuraOpacity)
  }

  @Builder
  buildWelcomeAuraLeft() {
    Stack() {
      Stack()
        .size({ width: 100, height: 800 })
        .borderRadius({ topRight: 100, bottomRight: 100 })
        .shadow({ radius: 150, color: Color.White, offsetX: 100 })
      Stack()
        .size({ width: 100, height: 640 })
        .borderRadius({ topRight: 100, bottomRight: 100 })
        .shadow({ radius: 130, color: Color.White, offsetX: 100 })
      Shape() {
        Path().commands('M0 0 C0 0 30 200 0 500 L0 200 Z').fill(Color.White).strokeOpacity(0)
      }.shadow({
        radius: 8,
        color: Color.White,
        type: ShadowType.BLUR,
        offsetX: 130,
      })
    }
    .alignContent(Alignment.Start)
    .useShadowBatching(true)
    .translate({ x: `${-0.53 * this.screenWidth}` })
    .opacity(this.welcomeAuraOpacity)
  }

  @Builder
  buildSecondary() {
    SpaceSwitchPreview({
      visible: this.secondaryVisible,
      screenWidthVp: this.screenWidth,
      spaceType: (this.showViewType === SpaceSwitchViewType.SwitchBack) ? this.currentSpaceType :
      this.secondarySpaceType,
      desktopWallpaper: this.desktopWallpaper,
      mySegmentAttr: this.mySegmentAttr,
      onLoading: this.onLoading && (this.showViewType === SpaceSwitchViewType.SwitchLeave),
      targetDirection: this.targetDirection,
      showViewType: this.showViewType,
      doubleStarOpacity: this.doubleStarOpacity,
    })
  }

  @Builder
  buildMain() {
    SpaceSwitchSnapshotView({
      visible: this.mainVisible,
      screenWidthVp: this.screenWidth,
      snapshotPic: this.snapshotPic,
      mySegmentAttr: this.mySegmentAttr,
    });
  }

  private shouldShowSwitchAnimation(): boolean {
    return this.showViewType === SpaceSwitchViewType.SwitchLeave ||
      this.showViewType === SpaceSwitchViewType.PrepareBack ||
      this.showViewType === SpaceSwitchViewType.SwitchBack;
  }

  build() {
    if (this.viewController.isShowing()) {
      if (this.showViewType === SpaceSwitchViewType.CreateLeave) {
        SCBSpaceLoadingView({ isVisible: true })
      } else {
        Stack() {
          if (this.shouldShowSwitchAnimation()) {
            if (this.showViewType !== SpaceSwitchViewType.SwitchBack) {
              this.buildBackground();
            }
            this.buildDoubleStar();
            if (this.secondarySpaceType !== SpaceTypeKey.None) {
              this.buildWelcomeAura();
              this.buildSecondary();
            }
            if (this.showViewType === SpaceSwitchViewType.SwitchLeave) {
              this.buildMain();
            }
          }
        }
      }
    }
  }
}