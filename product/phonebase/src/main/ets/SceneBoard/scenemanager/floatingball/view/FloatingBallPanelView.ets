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

import { LogDomain, Logger } from '@ohos/basicutils';
import { SceneConstants } from '@ohos/commonconstants';
import { FloatingBallInjector } from '../injector/FloatingBallInjector';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';
import { FloatingBallListView } from './FloatingBallListView';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { DeviceInfoVm, EnvVm } from '@ohos/systemuicommon/newIndex';
import { FloatingBall } from '../model/FloatingBallModel';
import { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import { ScreenProperty } from '../model/ScreenProperty';
import { RemoveType } from '../constants/FloatingConstants';
import { SCBFloatingBallPanelVm } from '../vm/SCBFloatingBallPanelVm';
import { Constants } from '../constants/FloatingConstants';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'FloatingBallPanelView';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

@ComponentV2
export struct FloatingBallPanelView {
  @Provider() injector: IFloatingBallInjector = new FloatingBallInjector();
  @Param @Require screenProperty: ScreenProperty;

  trashIconModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.ohos_trash'));
  removeIconModifier: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.minus_circle'));

  panelVm = this.injector.getPanelVm();
  rectVm = this.injector.getRectVm();
  listVm = this.injector.getListVm();
  menuVm = this.injector.getMenuVm();

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear`);
    const propertyWidth = SCBFloatingBallPanelVm.instance.propertyWidth;
    const propertyHeight = SCBFloatingBallPanelVm.instance.propertyHeight;
    const deviceWidth = DeviceInfoVm.instance.width;
    const deviceHeight = DeviceInfoVm.instance.height;
    // 保存的屏幕宽高与当前实际不一致时，恢复初始位置
    const propertyChanged = (propertyWidth !== 0 && propertyWidth !== deviceWidth) ||
      (propertyHeight !== 0 && propertyHeight !== deviceHeight);
    SCBFloatingBallPanelVm.instance.updateProperty(deviceWidth, deviceHeight);
    log.showInfo(TAG, `propertyChanged ${propertyChanged}`);
    this.rectVm.init();
    this.listVm.init();
    if (propertyChanged || SCBFloatingBallPanelVm.instance.firstAppear) {
      log.showWarn(TAG, 'first appear or propertyChanged, use default position');
      this.rectVm.defaultPosition(ArkUIAdapter.px2vp(this.screenProperty.width), true);
    }
    SCBFloatingBallPanelVm.instance.firstAppear = false;
    // 最后初始化
    this.panelVm.init();
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    this.injector.destroy();
  }

  @Builder
  renderFbSubWindow() {
    ForEach(
      this.listVm.floatingBallList,
      (item: FloatingBall, index?: number) => {
        if (item.specificSession?.session?.persistentId) {
          WindowScene(item.specificSession.session.persistentId)
            .width(1)
            .height(1)
            .zIndex(this.panelVm.zIndex)
            .visibility(Visibility.Visible)
            .hitTestBehavior(HitTestMode.Transparent)
        }
      }, (item: FloatingBall, index) => `${item.specificSession?.session?.persistentId}-${item.template}`)
  }

  @Builder
  longPressMenuBuilder() {
    Menu() {
      MenuItem({
        symbolStartIcon: this.removeIconModifier,
        content: $r('app.string.floating_ball_delete')
      })
        .onClick(() => {
          log.showInfo(TAG, `delete from Menu ${this.listVm.selectId}`);
          this.listVm.removeFloatingBall(this.listVm.selectId, RemoveType.LONG_PRESS_SINGLE);
          this.listVm.selectId = -1;
        })

      if (this.listVm.floatingBallList.length > 1) {
        MenuItem({
          symbolStartIcon: this.trashIconModifier,
          content: $r('app.string.floating_ball_delete_all'),
        })
          .onClick(() => {
            this.listVm.selectId = -1;
            this.listVm.clearAll(RemoveType.LONG_PRESS_ALL, true);
          })
      }
    }
    .font({size: 16})
    .menuItemDivider({
      strokeWidth: LengthMetrics.vp(0.5),
      color: '#d5d5d5',
      startMargin: LengthMetrics.vp(42),
      mode: DividerMode.EMBEDDED_IN_MENU
    })
    .width(FloatingBallStyle.MENU_WIDTH)
  }

  @Builder
  previewBuilder() {
    // 套一层固定宽度column使内层的宽度变化跟随对齐方式
    Column() {
      Stack(this.rectVm.isRight ? { alignContent: Alignment.End } : { alignContent: Alignment.Start }) {
        // 外底板
        this.outerPanelBuilder();
        // 蒙版
        this.overlayPanelBuilder();
        // 内底板
        this.innerPanelBuilder();
      }
      .size({ width: this.panelVm.outerPanelWidth, height: this.panelVm.outerPanelHeight })
      .borderRadius(FloatingBallStyle.RADIUS)
    }
    .size({ width: this.menuVm.width, height: this.menuVm.height })
    .scale({
      x: this.menuVm.scale,
      y: this.menuVm.scale,
      centerX: this.rectVm.isRight ? '100%' : '0%',
      centerY: '50%'
    })
    .alignItems(this.rectVm.isRight ? HorizontalAlign.End : HorizontalAlign.Start)
    .opacity(this.menuVm.opacity)
    .hitTestBehavior(HitTestMode.Block)
    .borderRadius(FloatingBallStyle.RADIUS)
  }

  build() {
    if (this.listVm.floatingBallList.length) {
      // 外层容器，用于处理屏幕旋转
      WindowScene(SceneConstants.TRANSFORM_SCENE) {
        // 放置应用的子窗，为应用保活
        this.renderFbSubWindow();
        // 放置悬浮球面板的系统窗口，用于显示内容
        WindowScene(this.panelVm.sceneSession?.session?.persistentId) {
          Stack() {
            // 外底板
            this.outerPanelBuilder();
            // 蒙版
            this.overlayPanelBuilder();
            // 内底板
            this.innerPanelBuilder();
          }
          .size({ width: this.panelVm.outerPanelWidth, height: this.panelVm.outerPanelHeight })
          .borderRadius(FloatingBallStyle.RADIUS)
          .foregroundEffect({ radius: this.rectVm.blurRadius })
        }
        .shadow({
          radius: this.panelVm.shadowRadius,
          color: FloatingBallStyle.SHADOW_COLOR,
        })
        .padding(this.rectVm.outerPadding)
        .gesture(PanGesture({ distance: 8 }) // 手势识别距离8vp
          .onActionStart((event: GestureEvent) => this.rectVm.onPanStart(event))
          .onActionUpdate((event: GestureEvent) => this.rectVm.onPanMove(event))
          .onActionEnd((event: GestureEvent) => this.rectVm.onPanEnd(event))
          .onActionCancel((event: GestureEvent) => this.rectVm.onPanEnd(event)))
        .onSizeChange(this.onPanelSizeChange)
        .id(`${this.panelVm.sceneSession?.name}${this.panelVm.sceneSession?.session?.persistentId}`)
        .zIndex(this.panelVm.zIndex)
        .visibility(Visibility.Visible)
        .position({ x: this.rectVm.position.x, y: this.rectVm.position.y })
        .focusable(true)
        .hitTestBehavior(HitTestMode.Default)
        .borderRadius(FloatingBallStyle.RADIUS)
        .scale({
          x: this.rectVm.scale,
          y: this.rectVm.scale,
          centerX: this.rectVm.scaleCenterX,
          centerY: this.rectVm.scaleCenterY,
        })
        .opacity(this.panelVm.opacity)
        .translate({ x: this.rectVm.translateX, y: this.rectVm.translateY })
        .onTouch((event?: TouchEvent) => this.panelVm.onTouchEvent(event))
        .id(Constants.FLOATING_BALL_PANEL_ID)
        .accessibilityLevel('no-hide-descendants')
        .bindContextMenu(
          this.menuVm.isShow,
          this.longPressMenuBuilder,
          {
            offset: {x: 0, y: 0},
            placement: Placement.BottomLeft,
            preview: this.previewBuilder,
            previewAnimationOptions: {
              scale: [0.9, 1.1],
            },
            // 菜单弹出时的事件回调
            onAppear: () => {
              log.showInfo(TAG, `menu onAppear`);
            },
            // 菜单显示动效前的事件回调
            aboutToAppear: () => {
              log.showInfo(TAG, `menu aboutToAppear`);
              // setTimeout设置透明度生效
              setTimeout(() => {
                this.panelVm.opacity = 0;
                this.menuVm.opacity = 1;
              });
            },
            aboutToDisappear: () => {
              log.showInfo(TAG, `menu aboutToDisappear`);
              this.panelVm.onMenuAboutDisappear();
            },
            // 菜单消失时的事件回调
            onDisappear: () => {
              log.showInfo(TAG, `menu onDisappear`);
              this.panelVm.onMenuDisappear();
            },
            modalMode: ModalMode.TARGET_WINDOW,
          })
      }
      .size({
        width: ArkUIAdapter.px2vp(this.screenProperty.width),
        height: ArkUIAdapter.px2vp(this.screenProperty.height)
      })
      .hitTestBehavior(HitTestMode.None)
      .visibility(this.panelVm.visible ? Visibility.Visible : Visibility.None)
      .zIndex(this.panelVm.zIndex)
      .rotate({
        x: 0,
        y: 0,
        z: 1,
        angle: -this.screenProperty.rotation,
        centerX: '50%',
        centerY: '50%'
      })
      .translate((this.screenProperty.rotation === 0 || this.screenProperty.rotation === 180) ? { x: 0, y: 0 } :
        { x: this.screenProperty.transX + 'px', y: this.screenProperty.transY + 'px' })
      .position({ x: this.screenProperty.left + 'px', y: this.screenProperty.top + 'px' })
    }
  }

  @Builder
  outerPanelBuilder() {
    Column() {
    }
    .width(this.panelVm.outerPanelWidth)
    .height(this.panelVm.outerPanelHeight)
    .borderRadius(FloatingBallStyle.RADIUS)
    .constraintSize({
      maxWidth: FloatingBallStyle.OUTER_MAX_WIDTH,
      minWidth: FloatingBallStyle.OUTER_MIN_WIDTH
    })
    .backgroundColor(this.getBackgroundColor())
    .foregroundEffect({ radius: this.rectVm.blurRadius })
    .position({ left: 0, top: 0 })
    .pixelRound({
      top: PixelRoundCalcPolicy.FORCE_FLOOR,
      bottom: PixelRoundCalcPolicy.FORCE_CEIL,
    })
  }

  @Builder
  innerPanelBuilder() {
    Column({ space: 4 }) {
      FloatingBallListView({
        floatingBallList: this.listVm.floatingBallList,
        screenProperty: this.screenProperty
      })
    }
    .width(this.panelVm.rowWidth)
    .position({ left: 4, top: 4 })
    .borderRadius(FloatingBallStyle.RADIUS)
    .justifyContent(FlexAlign.Center)
    .flexShrink(1)
    .foregroundEffect({ radius: this.rectVm.blurRadius })
  }

  @Builder
  overlayPanelBuilder() {
    // 蒙版
    Column() {
    }
    .position({ left: 0, top: 0 })
    .width(this.panelVm.outerPanelWidth)
    .height(this.panelVm.outerPanelHeight)
    .backgroundColor('#FFFFFF')
    .opacity(this.panelVm.overlayOpacity)
    .hitTestBehavior(HitTestMode.None)
    .borderRadius(FloatingBallStyle.RADIUS)
  }

  private onPanelSizeChange = (oldValue: SizeOptions, newValue: SizeOptions): void => {
    log.showInfo(TAG, `on panel size change ${oldValue.width} ${oldValue.height} to ${newValue.width} ${newValue.height}`);
    this.rectVm.onPanelSizeChange(newValue);
  }

  /**
   * 底板颜色
   */
  private getBackgroundColor(): ResourceColor {
    return EnvVm.instance.isDarkMode ? FloatingBallStyle.BACKGROUND_DARK : FloatingBallStyle.BACKGROUND_LIGHT;
  }
}