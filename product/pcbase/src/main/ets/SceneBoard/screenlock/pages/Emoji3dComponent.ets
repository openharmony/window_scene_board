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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PCUtils } from '../../../common/utils/PCUtils';
import Constants from '../common/Constants';
import StyleConfiguration, { AccountsComponentStyle } from '../common/StyleConfiguration';
import AccountsViewModel from '../vm/AccountsViewModel';
import { Emoji3dData, UserIconInfo } from '../vm/UserIconViewModel';
import { effectKit } from '@kit.ArkGraphics2D';
import { SCBWindowSceneConfig, WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { StyleConfigurationCommon } from '@ohos/systemuicommon';

const TAG = 'ScreenLock-Emoji3dComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const isPad: boolean = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === 'pad';

const MAX_RADIUS = 300;
/**
 * Three-dimensional Emoji Component
 */
@Component
export default struct Emoji3dComponent {
  @State transXForShadow: number = 0;
  @State transYForShadow: number = 0;
  @State transXForLight: number = 0;
  @State transYForLight: number = 0;
  @State scaleForLight: number = 1.2;
  @State opacityForLight: number = 0.4;
  @State userIconBgColor: Resource | string = '';
  @State guassianBlur: number = 0.8;
  @StorageLink('emojiMouseEvent') @Watch('onMouseEvent') mousePosition: Position = {x: 0, y: 0};
  @StorageLink('isWallPaperRegion') @Watch('setColorPickerRegion') isWallPaperRegion: number[] = [];

  private accountsStyle: AccountsComponentStyle | null = null;
  private anchorX: number = 0;
  private anchorY: number = 0;
  private isFirstMouseEvent: boolean = true;
  private isAnchorInit: boolean = false;
  private userIconInfo: UserIconInfo | null = null;
  private srcShadow: ResourceStr = '';
  private srcLight: ResourceStr = '';
  private srcBody: ResourceStr = '';
  private isEmojiDataLoadedSuccess: boolean = false;

  private initData(): void {
    if (!this.userIconInfo || !this.userIconInfo.iconImageMap.has(this.userIconInfo.iconType.toString())) {
      log.showError('emoji 3D data is null');
      return;
    }
    try {
      const emojiData: Emoji3dData =
        this.userIconInfo.iconImageMap.get(this.userIconInfo.iconType.toString()) as Emoji3dData;
      this.srcLight = emojiData.commonLightImg;
      this.srcShadow = emojiData.commonShadowImg;
      this.srcBody = emojiData.baseBodyImg;
      this.colorPickerforUserIconBG();
      if (CheckEmptyUtils.isEmpty(this.srcLight) || CheckEmptyUtils.isEmpty(this.srcShadow) ||
      CheckEmptyUtils.isEmpty(this.srcBody)) {
        log.showError('emoji 3D data loaded error');
        return;
      }
      this.isEmojiDataLoadedSuccess = true;
    } catch (e) {
      log.showError('init data error');
    }
  }

  setColorPickerRegion(): void {
    this.isWallPaperRegion = AppStorage.get<number[]>('isWallPaperRegion') as Array<number>;
  }

  aboutToAppear() {
    this.initData();
    this.colorPickerforUserIconBG();
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  onMouseEvent() {
    if (!this.isAnchorInit) {
      return;
    }
    if (this.isFirstMouseEvent) {
      this.isFirstMouseEvent = false; //过滤第一次鼠标事件，防止初始化时效果异常
      return;
    }
    let pos: Position = this.mousePosition;
    const currX: number = Number(pos.x);
    const currY: number = Number(pos.y);
    const flagX: number = currX < this.anchorX ? -1 : 1;
    const flagY: number = currY < this.anchorY ? -1 : 1;
    // 光效在边缘和中心时，亮度和范围不一样。在中心时，光效较大较暗。
    let lightScale = 1.8;
    let lightOpacity = 0.4;
    let dx: number = Math.abs(this.anchorX - currX);
    let dy: number = Math.abs(this.anchorY - currY);
    let currDistance: number = Math.sqrt(Math.pow(currX - this.anchorX, 2.0) + Math.pow(currY - this.anchorY, 2.0));
    if (currDistance > MAX_RADIUS) {
      lightScale = 1.8;
      lightOpacity = 0.4;
      let ratio: number = MAX_RADIUS / currDistance;
      dx = dx * ratio;
      dy = dy * ratio;
    }
    // 此处限定了光和影的最大移动范围
    const lightTransX: number = (dx / MAX_RADIUS) * 20 * flagX;
    const lightTransY: number = (dy / MAX_RADIUS) * 20 * flagY;
    const shadowTransX: number = -(dx / MAX_RADIUS) * 10 * flagX;
    const shadowTransY: number = -(dy / MAX_RADIUS) * 10 * flagY;
    animateTo({
      curve: curves.responsiveSpringMotion()
    }, () => {
      this.transXForLight = lightTransX;
      this.transYForLight = lightTransY;
      this.transXForShadow = shadowTransX;
      this.transYForShadow = shadowTransY;
      this.scaleForLight = lightScale;
      this.opacityForLight = lightOpacity;
      this.guassianBlur = 1 - Math.abs(0.6 * (this.transXForShadow / 8));
      log.showInfo(`transXForShadow: ${this.transXForShadow}, transYForShadow: ${this.transYForShadow}`)
    })
  }

  @Builder
  lightImgBuilder(offsetX: number, offsetY: number) {
    Image(this.srcLight)
      .autoResize(false)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .translate({ x: this.transXForLight + offsetX, y: this.transYForLight + offsetY })
      .scale({x: this.scaleForLight, y: this.scaleForLight, centerX: '50%', centerY: '50%'})
      .opacity(this.opacityForLight)
      .width(this.accountsStyle?.userIconWidth)
      .height(this.accountsStyle?.userIconHeight)
      .borderRadius(this.accountsStyle?.lightOnUserIconRadius)
  }

  private async colorPickerforUserIconBG(): Promise<Resource> {
    let wallpaper: image.PixelMap =
      await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.SCEENLOCK, TAG);
    let leftSide: number = ((this.isWallPaperRegion[0] - Constants.USER_ITEM_SIZE) * Constants.A_HALF) /
    this.isWallPaperRegion[0];
    let rightSide: number = leftSide + Constants.USER_ITEM_SIZE / this.isWallPaperRegion[0];
    let topSide: number = this.isWallPaperRegion[2] / this.isWallPaperRegion[1];
    let bottomSide: number = (this.isWallPaperRegion[2] + Constants.USER_ITEM_SIZE) / this.isWallPaperRegion[1];

    let colorPicker = await effectKit.createColorPicker(wallpaper, [leftSide, topSide, rightSide, bottomSide]);
    log.showInfo(`handleScreenLockWallpaperChange font color,
    screenWidth: ${this.isWallPaperRegion[0]}, screenHeight: ${this.isWallPaperRegion[1]},
    accountTopMargin: ${this.isWallPaperRegion[2]}`);
    let iconBgColor = colorPicker.getAverageColor();
    return AccountsViewModel.getInstance().handleWallpaperAvgColor(iconBgColor);
  }

  private userIconColorCapture(): Resource {
    this.colorPickerforUserIconBG().then((colorCode) => {
      return colorCode;
    })
    return $r('app.color.screenLock_row_baseplate_background_color');
  }

  @Builder
  backgroundImgBuilder() {
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%') //color: this.userIconBgColor,
      .backgroundEffect({
        color: '#4DE6E6E6',
        saturation: 1.8,
        brightness: 1.1,
        radius: 60
      })
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundEffect({
        radius: 60,
        color: this.userIconColorCapture(),
        saturation: 1.2
      })
      .opacity(0.2)
      .borderRadius(60)
    }
  }

  @Builder
  bodyImgBuilder() {
    Image(this.srcBody)
      .autoResize(false)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
  }

  @Builder
  gaussianBlurBuilder(offsetX?: number, offsetY?: number) {
    Stack() {
      Image($r('app.media.screenlock_gaussianhighlight'))
        .autoResize(false)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)

        .opacity(this.guassianBlur)
      Stack()
        .backgroundColor('#00ffffff')
        .backgroundBrightness({
          rate: 0.25,
          lightUpDegree: 0.4
        })
    }.scale({
      x: 0.3,
      y: 0.3,
      centerX: '50%',
      centerY: '50%'
    })
    .translate({ x: this.transXForShadow, y: this.transYForShadow < -4.5 ? this.transYForShadow : -4.5 })
    .margin({
      top: 44
    })
  }

  @Builder
  public animationBuilder(): void {
    this.backgroundImgBuilder()
    Image(this.srcShadow)
      .autoResize(false)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .translate({ x: this.transXForShadow, y: this.transYForShadow })
      .opacity(0.5)
    this.gaussianBlurBuilder();
    this.bodyImgBuilder();
    Stack() {
      // 限定光效只能在脑袋上移动，进行边界切割。注意需要还原光的初始位置
      this.lightImgBuilder(0.4, 4);
    }
    .width(this.accountsStyle?.lightOnHeadSize)
    .height(this.accountsStyle?.lightOnHeadSize)
    .borderRadius(this.accountsStyle?.lightOnHeadSize)
    .translate(this.accountsStyle?.lightOnHeadTrans)
    .clip(true)
    Stack() {
      // 限定光效只能在身体上移动，进行边界切割。注意需要还原光的初始位置
      this.lightImgBuilder(0, -80);
    }
    .width(this.accountsStyle?.lightOnBodySize)
    .height(this.accountsStyle?.lightOnBodySize)
    .borderRadius(this.accountsStyle?.lightOnBodySize)
    .translate(this.accountsStyle?.lightOnBodyTrans)
    .clip(true)
  }

  build() {
    Stack() {
      if (!this.isEmojiDataLoadedSuccess) {
        Image(this.userIconInfo?.iconImage)
          .autoResize(false)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium);
      } else if (PCUtils.is2D() || AccountsViewModel.getInstance().selectedUserId === Constants.INVALID_USER_ID) {
        this.backgroundImgBuilder();
        this.bodyImgBuilder();
      } else {
        this.animationBuilder()
      }
    }
    .id(Constants.KEY_USER_ICON)
    .width(this.accountsStyle?.userIconWidth)
    .height(this.accountsStyle?.userIconHeight)
    .borderRadius(this.accountsStyle?.userIconRadius)
    .shadow({ radius: 30, color: $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark'), offsetY: 4 })
    .clip(true)
    .onAreaChange((oldValue, newValue) => {
      if (!this.isEmojiDataLoadedSuccess) {
        log.showDebug(`isEmojiDataLoadedSuccess:${this.isEmojiDataLoadedSuccess}`);
        return;
      }
      let selectedUsr: number | undefined = AccountsViewModel.getInstance().selectedUserId;
      if (PCUtils.is2D() || AccountsViewModel.getInstance().selectedUserId === Constants.INVALID_USER_ID) {
        log.showDebug(`isSelectUser: ${selectedUsr}`);
        return;
      }
      this.isAnchorInit = true;
      const x: number = Number(newValue.globalPosition.x);
      const y: number = Number(newValue.globalPosition.y);
      const width: number = Number(newValue.width);
      const height: number = Number(newValue.height);
      this.anchorX = x + (width / 2.0);
      this.anchorY = y + (height / 2.0);
      log.showInfo('set anchor finish');
    })
  }
}