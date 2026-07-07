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

import commonEvtMgr from '@ohos.commonEventManager';
import { CommonUtils, DomainName, LogDomain, Logger, TraceUtil } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  ACTIVE_STATUS_MAP,
  SCBKeyboardManager,
  SCBKeyboardSession,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SCBSystemSceneSession,
  ScenePanelState,
  SpecificPanelZOrder,
  SystemSessionInfo
} from '@ohos/windowscene';
import { AnimationBase } from '@ohos/systemuicommon/newIndex';
import { curves } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { CEManager, CustomPromise, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { IFloatingBallPanelVm } from '../interface/IFloatingBallPanelVm';
import { FloatingBallBaseVm } from './FloatingBallBaseVm';
import { FloatingBall } from '../model/FloatingBallModel';
import { SCBDefaultZIndex } from '../../SCBScreen';
import { IFloatingBallRectVm } from '../interface/IFloatingBallRectVm';
import { Constants, FBTemplate, IScenePanelStateData, RemoveType } from '../constants/FloatingConstants';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { SubscriberUtils } from '../common/SubscriberUtils';
import { IFloatingBallListVm } from '../interface/IFloatingBallListVm';
import { SCBConstants } from '@ohos/commonconstants';
import { DefaultPanelZIndex, SystemUICommonUtil } from '@ohos/systemuicommon';
import { SCBFloatingBallPanelVm } from './SCBFloatingBallPanelVm';
import { SubscriberInfo } from '../constants/FloatingConstants';
import { SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { TO_SIDE_CURVE, LONG_PRESS_CURVE } from '../animation/FloatingBallAnimation';
import { IFloatingBallMenuVm } from '../interface/IFloatingBallMenuVm';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';
import { RecentGestureCallback, RecentGestureEventManager } from '../../../recent/common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../../recent/common/constants/RecentGestureConstants';
import { OneStepStateVm } from './OneStepStateVm';
import { OneStepState } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { FloatingBallOneMirrorAnimation } from '@ohos/systemuicommon/src/main/ets/animation/FloatingBallOneMirrorAnimation';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'FloatingBallPanelVm';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ObservedV2
export class FloatingBallPanelVm extends FloatingBallBaseVm implements IFloatingBallPanelVm {
  private static readonly ROTATION_CURVE: ICurve = curves.springMotion(0.4, 1);
  private fbSpecificSessionList = new SCBSpecificSceneSessionList();
  private zOrder = SpecificPanelZOrder.FLOATING_BALL as number;

  @Trace public zIndex: number = DefaultPanelZIndex.PANEL_FLOATING_BALL;
  @Trace public visible = false;
  @Trace public rowWidth: number = FloatingBallStyle.INNER_ROW_MIN_WIDTH;
  @Trace public overlayOpacity: number = 0;
  @Trace public rotateAngle: number = 0;
  @Trace public outerPanelWidth: number = 0;
  @Trace public outerPanelHeight: number = 0;
  @Trace public opacity: number = 0;
  @Trace public shadowRadius: number = 10;

  public sceneSession?: SCBSystemSceneSession;
  private oneStepStateVm = OneStepStateVm.instance;
  private RECENT_SHOW_MAP: Map<RecentGestureEvent, string> = new Map([
    // 一步手势进入悬浮窗开始
    [RecentGestureEvent.ENTER_APP_FLOAT, 'show'],
    // 一步手势进入分屏开始
    [RecentGestureEvent.ENTER_APP_SPLIT, 'show'],
  ]);

  private subscriber?: SubscriberUtils;
  // 串行拉起主窗，避免快速点击反复做动效
  private restorePromise?: CustomPromise<void> = undefined;

  constructor(vmInjector: IFloatingBallInjector) {
    log.showInfo(TAG, 'panel vm constructor');
    super(vmInjector);
  }

  /**
   * 获取悬浮球位置VM
   * @returns
   */
  @Computed
  public get rectVm(): IFloatingBallRectVm {
    return this.vmInjector.getRectVm();
  }

  /**
   * 获取悬浮球List VM
   * @returns
   */
  @Computed
  public get listVm(): IFloatingBallListVm {
    return this.vmInjector.getListVm();
  }

  /**
   * 获取悬浮球Menu VM
   * @returns
   */
  @Computed
  public get menuVm(): IFloatingBallMenuVm {
    return this.vmInjector.getMenuVm();
  }

  @Monitor('oneStepStateVm.state')
  onOneStepStateChange(monitor: IMonitor): void {
    log.showInfo(TAG, `oneStepState from ${monitor.value()?.before} to ${monitor.value()?.now}`);
    const state = monitor.value()?.now as OneStepState;
    if ([OneStepState.SHOW_BG_AND_ICON, OneStepState.ENTER_FLOATING, OneStepState.ENTER_SPLIT].includes(state)) {
      this.setVisibility(false);
    }
  }

  private onCreateSpecificScene = async (session: sceneSessionManager.SceneSession): Promise<void> => {
    log.showInfo(TAG, `createSpecificScene ${session.persistentId}`);
    if (!this.sceneSession) {
      this.createSystemSceneSession();
    }

    const oldSession = this.fbSpecificSessionList.find((old) => old.session.persistentId === session.persistentId);
    if (oldSession) {
      log.showWarn(TAG, `session is already in list, ${session.bundleName}:${session.persistentId}`);
      return;
    }
    try {
      const spSceneSession = new SCBSpecificSession(session, this.onSessionStateChange);
      session?.setFocusable(false);
      this.fbSpecificSessionList.push(spSceneSession);
      spSceneSession.enableSessionStateChange();
      spSceneSession.isActive = true;
      await this.parseTemplate(spSceneSession, true);
      this.listenSessionCallback(session, spSceneSession);
      log.showInfo(TAG, `Create floating ball end, ${session.bundleName}:${session.persistentId}, ` +
        `current ball size: ${this.listVm.floatingBallList.length}`);
    } catch (e) {
      log.showError(TAG, 'Create floating ball error:', e);
    }
  };

  /**
   * 状态变化回调
   */
  private onSessionStateChange = (parentId: number, persistentId: number,
    state: sceneSessionManager.SessionState): void => {
    const specificSession = this.fbSpecificSessionList.find((old) => old.session.persistentId === persistentId);
    if (!specificSession) {
      log.showWarn(TAG, `can not find session with id ${persistentId}`);
      return;
    }
    const bundleName = specificSession.session.bundleName;
    log.showInfo(TAG, `${bundleName}:${persistentId} session state change to ${state}`);
    const isActive = ACTIVE_STATUS_MAP.get(state);
    if (isActive === undefined) {
      log.showWarn(TAG, `can not find session with state ${state} for id ${persistentId}`);
      return;
    }
    specificSession.isActive = isActive;
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      log.showInfo(TAG, `${bundleName}:${persistentId} disconnect, session ref ${specificSession.getRefCount()}`);
      this.listVm.removeFloatingBall(persistentId, RemoveType.KILL_PROCESS);
      specificSession.unregisterSessionStateChangeCallback(this.onSessionStateChange);
      this.fbSpecificSessionList.splice(this.fbSpecificSessionList.indexOf(specificSession), 1);
    } else if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
      log.showInfo(TAG, `${bundleName}:${persistentId} foreground`);
    }
    SCBSceneSessionManager.getInstance().updateHomeOccludedState(this.fbSpecificSessionList, this.zOrder);
  };

  public init(): void {
    this.zIndex = DefaultPanelZIndex.PANEL_FLOATING_BALL;
    this.keyboardRectChangeCallback(); // 尝试更新输入法高度
    this.initScreenProperty();
    SCBFloatingBallPanelVm.instance.registerOnCreateSession(this.onCreateSpecificScene);
  }

  private initScreenProperty(): void {
    const property = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    log.showInfo(TAG, `panel Vm init, width ${property.width}, height ${property.height}`);
    this.rectVm.updateScreenProperty(property.width, property.height);
  }

  /**
   * 监听session的回调
   * @param session
   * @param spSceneSession
   */
  private listenSessionCallback(session: sceneSessionManager.SceneSession, spSceneSession: SCBSpecificSession): void {
    // 更新
    session.on('updateFbTemplateInfo', (template) => {
      log.showInfo(TAG, `updateFbTemplateInfo for ${session.persistentId} template:${JSON.stringify(template)}`);
      session.fbTemplateInfo = template;
      this.parseTemplate(spSceneSession);
    });
    // 删除
    session.on('prepareRemoveFb', () => {
      log.showInfo(TAG, `prepareRemoveFb for ${session.persistentId}`);
      // 先从列表删除
      this.listVm.removeFloatingBall(session.persistentId, RemoveType.APP);
    });
    // 拉起应用
    session.on('restoreFbMainWindow', (want: Want) => {
      log.showInfo(TAG, `restoreFbMainWindow ${want?.bundleName}, id ${session.persistentId}`);
      if (session.bundleName !== want.bundleName) {
        log.showInfo(TAG, `restoreFbMainWindow bundleName is not right`);
        return;
      }
      this.restoreFbMainWindow(want, session.persistentId);
    });
  }

  /**
   * 创建0层控件
   */
  private createSystemSceneSession() {
    log.showInfo(TAG, `create system scene session`);
    try {
      const systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_FLOATING_BALL,
        sceneName: 'Fb_panel', // 底层需要
        sceneZIndex: SCBDefaultZIndex.FLOATING_BALL,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        isRotatable: true,
        hitTestMode: HitTestMode.None,
        sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
      };
      this.sceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo);
      if (CommonUtils.isInvalid(this.sceneSession)) {
        log.showInfo(TAG, `system scene session is invalid`);
        return;
      }
      this.sceneSession.setSkipEventAndShowOnVirtualScreen(true);
      this.sceneSession.session.on('touchOutside', () => {
        this.menuVm.isShow = false;
      });
      this.initCallbacks();
    } catch (err) {
      this.destroy();
      log.showError(TAG, `create system scene session error:${err}`);
    }
  }

  /**
   * 注册事件回调
   */
  private initCallbacks() {
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyCallback);
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.screenRotateChangeCallback);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(this.onScreenPropertyChange,
      SCBDefaultZIndex.FLOATING_BALL);
    SCBKeyboardManager.getInstance().registerKeyboardShowCallback(this.inputShowCallback);
    SCBKeyboardManager.getInstance().registerkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    this.initSubscriberEvent();
    this.subscribeGestureEvent();
  }

  /**
   * 订阅多任务公共事件
   */
  private initSubscriberEvent(): void {
    const info = new SubscriberInfo(
      Constants.SUBSCRIBER_NAME,
      { events: [CEManager.CUSTOM_SCENE_PANEL_EVENT], publisherBundleName: Constants.PACKAGE_NAME },
      (data: commonEvtMgr.CommonEventData) => this.handleScenePanelStateChange(data)
    );
    this.subscriber = new SubscriberUtils();
    const subscriberInfos: SubscriberInfo[] = [info];
    this.subscriber?.init(subscriberInfos);
  }

  private recentGestureCallback: RecentGestureCallback = {
    onGestureEvent: () => {
      log.showInfo(TAG, 'onRecentGestureEvent');
      this.setVisibility(true);
      return true;
    }
  };

  public subscribeGestureEvent(): void {
    this.RECENT_SHOW_MAP.forEach((value, key) => {
      RecentGestureEventManager.getInstance().subscribeGestureEvent(key, this.recentGestureCallback);
    });
  }

  public unSubscribeGestureEvent(): void {
    this.RECENT_SHOW_MAP.forEach((value, key) => {
      RecentGestureEventManager.getInstance().unSubScribeGestureEvent(key, this.recentGestureCallback);
    });
  }

  public destroy() {
    log.showInfo(TAG, `panel vm destory`);
    SCBFloatingBallPanelVm.instance.unRegisterOnCreateSession();
    if (this.sceneSession) {
      log.showInfo(TAG, `destory system scene session`);
      this.sceneSession.setSkipEventAndShowOnVirtualScreen(false);
      SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.sceneSession);
      this.sceneSession = undefined;
    }
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.screenRotateChangeCallback);
    SCBKeyboardManager.getInstance().unRegisterKeyboardShowCallback(this.inputShowCallback);
    SCBKeyboardManager.getInstance().unRegisterkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    SCBScreenSessionManager.getInstance().unRegisterPropertyChangeScenePanelCallback(this.onScreenPropertyChange,
      SCBDefaultZIndex.FLOATING_BALL);

    this.subscriber?.unInit();
    this.unSubscribeGestureEvent();
    this.subscriber = undefined;
    // 重置状态
    this.menuVm.isShow = false;
  }

  private screenPropertyCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(TAG, `screenPropertyCallback ${reason}, ${screenProperty.width}, ${screenProperty.height}`);
    this.rectVm.updateScreenProperty(screenProperty.width, screenProperty.height);
    if (this.isScreenPropertyChanged(screenProperty)) {
      this.defaultPosition(screenProperty);
    }
    SCBFloatingBallPanelVm.instance.updateProperty(screenProperty.width, screenProperty.height);
  };

  private isScreenPropertyChanged(screenProperty: SCBScreenProperty): boolean {
    log.showInfo(TAG, `callback size ${screenProperty.width}, ${screenProperty.height}, ` +
      `save size ${SCBFloatingBallPanelVm.instance.propertyWidth}, ${SCBFloatingBallPanelVm.instance.propertyHeight}`);
    return screenProperty.width !== SCBFloatingBallPanelVm.instance.propertyWidth ||
      screenProperty.height !== SCBFloatingBallPanelVm.instance.propertyHeight;
  }

  public tryAvoidKeyboard(): void {
    this.inputShowCallback(SCBKeyboardManager.getInstance().getKeyboardSession(), false);
  }

  /**
   * 输入法显示
   */
  private inputShowCallback = (inputSession: SCBKeyboardSession, withAnim: boolean = true): void => {
    log.showInfo(TAG, `inputShowCallback`);
    const keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (CommonUtils.isInvalid(inputSession) || CommonUtils.isInvalid(keyboardPanelSession)) {
      log.showInfo(TAG, `inputShowCallback isvalid return`);
      return;
    }
    // 悬浮键盘不避让
    if (inputSession.isFloatGravity()) {
      log.showInfo(TAG, `inputShowCallback isFloatGravity reset inputHeight 0`);
      this.rectVm.updateInputMethodHeight(0);
      return;
    }
    // 判断是否需要避让输入法
    if (!inputSession.isKeyboardShowing()) {
      log.showInfo(TAG, `inputShowCallback hide`);
      this.rectVm.updateInputMethodHeight(0);
      return;
    }
    log.showInfo(TAG, `inputShowCallback show`);
    // 输入法高度(px)
    const inputRealHeight: number = keyboardPanelSession.getPanelRealHeight();
    this.rectVm.updateInputMethodHeight(inputRealHeight);
    log.showInfo(TAG, `inputShowCallback Y:${this.rectVm.getDistanceFromLeftBottom()} > ${px2vp(inputRealHeight)}`);
    if (this.rectVm.getDistanceFromLeftBottom() > ArkUIAdapter.px2vp(inputRealHeight)) {
      log.showInfo(TAG, `inputShowCallback ball doesnot overlay input return`);
      return;
    }

    if (!this.rectVm.isOverlayInputMethod()) {
      return;
    }
    log.showInfo(TAG, `inputShowCallback isOverlayInputMethod`);
    if (withAnim) {
      animateTo({
        curve: TO_SIDE_CURVE
      },
        () => {
          this.rectVm.avoidInputMethod();
        });
    } else {
      this.rectVm.avoidInputMethod();
    }
    return;
  };

  /**
   * 输入法尺寸变化
   */
  private keyboardRectChangeCallback = (): void => {
    log.showInfo(TAG, `keyboardRectChangeCallback`);
    const keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (CommonUtils.isInvalid(keyboardSession)) {
      log.showInfo(TAG, `keyboardRectChangeCallback session is isvalid return`);
      return;
    }
    if (keyboardSession.isFloatGravity()) {
      log.showInfo(TAG, `keyboardRectChangeCallback isFloatGravity reset inputHeight 0`);
      this.rectVm.updateInputMethodHeight(0);
      return;
    }

    const keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (CommonUtils.isInvalid(keyboardPanelSession)) {
      log.showInfo(TAG, `keyboardRectChangeCallback panel is isvalid return`);
      return;
    }
    const isKeyboardShowing = keyboardSession.isKeyboardShowing();
    log.showInfo(TAG, `keyboardRectChangeCallback isKeyboardShowing ${isKeyboardShowing}`);
    if (isKeyboardShowing) {
      let inputRealHeight: number = keyboardPanelSession.getPanelRealHeight();
      this.rectVm.updateInputMethodHeight(inputRealHeight);
      // 键盘形态(悬浮->普通)切换后,重新判断当前位置是否与键盘重合
      if (this.rectVm.isOverlayInputMethod()) {
        animateTo({
          curve: TO_SIDE_CURVE
        },
          () => {
            this.rectVm.avoidInputMethod();
          });
      }
    }
  };

  private screenRotateChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    log.showInfo(TAG, `screenRotateChangeCallback ${reason}, ${screenProperty.width}, ${screenProperty.height}`);
    this.rectVm.updateScreenProperty(screenProperty.width, screenProperty.height);
  }

  private onScreenPropertyChange = async (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(TAG, `ScreenPropChange ${reason} rotation ${screenProperty.rotation} width ${screenProperty.width}`);
    if (this.isScreenPropertyChanged(screenProperty)) {
      this.defaultPosition(screenProperty);
    }
    // 旋转时关闭垃圾桶并重置缩放比例
    if (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      log.showInfo(TAG, 'ScreenPropChange change: ROTATION');
      this.rectVm.scale = 1;
      this.rectVm.updateScaleCenter('50%', '50%');
    }
  };

  private async defaultPosition(screenProperty: SCBScreenProperty): Promise<void> {
    await this.rectVm.updateCutoutArea();
    const animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_DEFAULT_POSITION_ANIMATION);
    await animation.executeAnimation([{
      curve: FloatingBallPanelVm.ROTATION_CURVE,
      event: () => {
        this.rotateAngle = screenProperty.rotation;
        this.rectVm.defaultPosition(ArkUIAdapter.px2vp(screenProperty.width) - this.outerPanelWidth, true);
      },
    }]);
  }

  public getSpSessionList = (): SCBSpecificSceneSessionList => {
    return this.fbSpecificSessionList;
  };

  /**
   * 解析模板
   * @param specificSession
   */
  private async parseTemplate(specificSession: SCBSpecificSession, isCreate: boolean = false): Promise<void> {
    try {
      const fbTemplate: sceneSessionManager.FbTemplateInfo = specificSession.session.fbTemplateInfo;
      const persistentId: number = specificSession.session.persistentId;
      if (!fbTemplate || !persistentId) {
        const bundleName = specificSession.session.bundleName;
        log.showError(TAG, `floating ball ${bundleName}:${persistentId} no template or persistentId!`);
        return;
      }

      // 创建
      if (isCreate) {
        await this.createFloatingBall(specificSession);
      } else {
        this.updateFloatingBall(persistentId, fbTemplate);
      }
    } catch (err) {
      log.showError(TAG, `parse template err, ${err}`);
    }
  }

  public fillTemplateToBall(ball: FloatingBall, fbTemplate: sceneSessionManager.FbTemplateInfo): void {
    ball.icon = fbTemplate.icon;
    ball.title = fbTemplate.title;
    ball.backgroundColor = fbTemplate.backgroundColor;
    ball.content = fbTemplate.content ?? '';
    const templates = [FBTemplate.STATIC, FBTemplate.NORMAL, FBTemplate.EMPHATIC, FBTemplate.SIMPLE];
    if (templates.includes(fbTemplate.template as number)) {
      ball.template = fbTemplate.template as number;
    }
  }

  /**
   * 创建悬浮球,若已创建，则忽略后续创建
   * @param specificSession
   */
  private async createFloatingBall(specificSession: SCBSpecificSession): Promise<void> {
    const persistentId: number = specificSession.session.persistentId;
    if (this.listVm.isExist(persistentId)) {
      log.showInfo(TAG, `${persistentId} is exist in list`);
      return;
    }
    const fbTemplate: sceneSessionManager.FbTemplateInfo = specificSession.session.fbTemplateInfo;
    const ball = new FloatingBall(specificSession);
    this.fillTemplateToBall(ball, fbTemplate);
    await this.listVm.addFloatingBall(ball);
  }

  /**
   * 更新悬浮球,若没有找到则忽略本次更新
   * @param specificSession
   */
  private async updateFloatingBall(persistentId: number,
    fbTemplate: sceneSessionManager.FbTemplateInfo): Promise<void> {
    const ball = this.listVm.getFloatingBall(persistentId);
    if (!ball) {
      log.showWarn(TAG, `not found ball by ${persistentId}`);
      return;
    }
    const newBall = new FloatingBall(ball.specificSession);
    this.fillTemplateToBall(newBall, fbTemplate);
    this.listVm.updateFloatingBall(newBall);
  }

  /**
   * 拉起应用
   * @param want
   */
  private async restoreFbMainWindow(want: Want, persistentId: number): Promise<void> {
    await this.restorePromise;
    this.restorePromise = new CustomPromise();
    try {
      const ball = this.listVm.getFloatingBall(persistentId);
      if (!ball || !ball.specificSession || !want.bundleName) {
        log.showWarn(TAG, 'invalid ball or bundleName');
        return;
      }
      const parentId = ball.specificSession.session.parentId;
      log.showInfo(TAG, `ball ${ball.specificSession.session.persistentId} parentId ${parentId}`);
      const parentSession = this.findParentSession(parentId);
      if (!parentSession) {
        log.showError(TAG, `${parentId} can not find parentSession`);
        return;
      }
      if (!want.parameters) {
        want.parameters = {};
      }
      want.parameters[SCBConstants.START_APP_CLONE_INDEX] = parentSession.sceneInfo.appIndex;
      const isLaunchMultiAbility = this.isLaunchMultiAbility(parentSession, want);
      // if (!isLaunchMultiAbility) {
      //   log.showInfo(TAG, `${parentId} is in side edge bar`);
      //   return;
      // }
      const isNeedOneMirror = !parentSession.isActive || isLaunchMultiAbility;
      let promise = Promise.resolve();
      if (isNeedOneMirror) {
        promise = FloatingBallOneMirrorAnimation.instance.prepare({
          scene: SystemUIUseScene.FLOATING_BALL,
          cardRect: SystemUICommonUtil.getRect(Constants.FLOATING_BALL_PANEL_ID),
          cardRadius: FloatingBallStyle.RADIUS,
          bundleName: want.bundleName,
          cardBgColor: FloatingBallStyle.BG_COLOR,
          onExecute: () => {
            log.showInfo(TAG, 'onExecute');
          },
        }).then(() => {
          log.showInfo(TAG, 'prepare finish');
        });
      }
      const context = GlobalContext.getContext();
      const startPromise = context.startAbility(want).then(() => {
        log.showInfo(TAG, `restoreFbMainWindow succeed`);
      }).catch((err: Error ) => {
        log.showError(TAG, `restoreFbMainWindow failed, code is ${(err as BusinessError).code}, message is ${err.message}`);
      });
      await Promise.all([promise, startPromise]);
    } catch (err) {
      log.showError(TAG, `catch err restoreFbMainWindow, ${err}`);
    } finally {
      this.restorePromise?.resolve();
      this.restorePromise = undefined;
    }
  }

  private findParentSession(parentId: number): SCBSceneSession | undefined {
    const parentSession = SCBSceneSessionManager.getInstance().findMainSessionById(parentId);
    if (parentSession) {
      return parentSession;
    }
    log.showWarn(TAG, `${parentId} can not find main parentSession, try find in side edge.`);
    const sideParentSession =
      SCBSceneSessionManager.getInstance().getSideEdgeSessionList().getSessionByPersistentId(parentId);
    if (sideParentSession instanceof SCBSceneSession) {
      return sideParentSession;
    }
    return undefined;
  }

  private isLaunchMultiAbility(parentSession: SCBSceneSession, want: Want): boolean {
    const sceneInfo = parentSession.sceneInfo;
    const bundleName = this.getInfoWithDefault(want?.bundleName, sceneInfo.bundleName);
    const moduleName = this.getInfoWithDefault(want?.moduleName, sceneInfo.moduleName);
    const abilityName = this.getInfoWithDefault(want?.abilityName, sceneInfo.abilityName);
    const queryKey = bundleName + moduleName + abilityName;
    const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    log.showInfo(TAG, `queryKey ${queryKey}, launchType ${launchType}`);
    return [bundleManager.LaunchType.MULTITON, bundleManager.LaunchType.SPECIFIED].includes(launchType);
  }

  private getInfoWithDefault(value: string | undefined, defaultValue: string): string {
    log.showInfo(TAG, `value is ${value}, default is ${defaultValue}`);
    if (value && value !== '') {
      return value;
    }
    return defaultValue;
  }

  /**
   * 是否处于多任务
   * @returns boolean
   */
  private isRecentState(): boolean {
    const screenProperty: SCBScreenProperty =
      SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty;
    const isShowRecent = SCBSceneSessionManager.getInstance().isScenePanelInState(screenProperty?.screenId,
      ScenePanelState.RECENT);
    return isShowRecent;
  }

  private setVisibility(visible: boolean): void {
    if (!this.sceneSession) {
      log.showInfo(TAG, `sceneSession is not right ${visible}`);
      return;
    }
    // 多任务下不展示
    if (visible && this.isRecentState()) {
      log.showInfo(TAG, `not show in recent state`);
      return;
    }
    log.showInfo(TAG, `setVisibility: ${visible} ${this.listVm.floatingBallList.length}`);
    if (!this.listVm.floatingBallList.length) {
      this.sceneSession.setVisibility(false);
      this.visible = false;
      return;
    }
    this.sceneSession.setVisibility(visible);
    this.visible = visible;
  }

  @Computed
  public get checkPanelVisibility(): number {
    log.showInfo(TAG, `checkPanelVisibility, floatingBall length ${this.listVm.floatingBallList.length}`);
    if (this.listVm.floatingBallList.length) {
      log.showInfo(TAG, 'Show panel');
      this.setVisibility(true);
    } else if (!this.listVm.floatingBallList.length) {
      log.showInfo(TAG, 'Hide panel');
      this.setVisibility(false);
    }
    return 0;
  }

  public onTouchEvent(event?: TouchEvent): void {
    if (event?.type === TouchType.Down) {
      log.showInfo(TAG, 'touch down');
      this.touchEffectAnimation(0.9);
    } else if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      log.showInfo(TAG, 'touch up');
      if (this.rectVm.isInDelArea) {
        log.showInfo(TAG, 'in del area, no need update scale'); // 垃圾桶删除区域内松手，不做动效，避免与删除动效冲突
        return;
      }
      this.touchEffectAnimation(1);
    }
  }

  private async touchEffectAnimation(scale: number): Promise<void> {
    const scaleAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_PANEL_SCALE_ANIMATION,
      true);
    await scaleAnimation.executeAnimation([{
      curve: curves.interpolatingSpring(10, 1, 410, 38),
      event: () => {
        this.rectVm.scale = scale;
      },
    }]);
  }

  public onMenuAboutDisappear(): void {
    const longPressAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_LONG_PRESS_ANIMATION,
      true);
    longPressAnimation.executeAnimation([{
      curve: LONG_PRESS_CURVE,
      duration: 300,
      event: () => {
        this.overlayOpacity = 0;
        this.listVm.restoreAllFloatingBallsOpacity();
      },
    }]);
  }

  public onMenuDisappear(): void {
    log.showInfo(TAG, `menu disappear, panel removing ${this.rectVm.isRemoving}`);
    this.menuVm.opacity = 0;
    // 全部删除的情况下，原面板不用再恢复
    if (!this.rectVm.isRemoving) {
      this.opacity = 1;
    }
    this.menuVm.isShow = false;
    TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.MENU_SHOW_AND_HIDE);
  }

  /**
   * 处理多任务事件回调
   * @param eventData
   */
  private handleScenePanelStateChange(eventData: commonEvtMgr.CommonEventData): void {
    if (!eventData || !eventData.event) {
      log.showInfo(TAG, `recv data or event is null`);
      return;
    }
    switch (eventData.event) {
      case CEManager.CUSTOM_SCENE_PANEL_EVENT:
        const parameters = eventData.parameters as IScenePanelStateData;
        if (parameters) {
          if (parameters.destState === ScenePanelState.RECENT) {
            // 进入多任务
            log.showInfo(TAG, `enter to recent`);
            this.setVisibility(false);
          } else if ([ScenePanelState.HOME, ScenePanelState.FULLSCENE].includes(parameters.destState)) {
            // 回到桌面或进入应用
            log.showInfo(TAG, `back to home`);
            this.setVisibility(true);
          }
        }
        break;
      default:
        log.showWarn(TAG, `recv not match event: ${eventData.event}`);
        break;
    }
  }
}