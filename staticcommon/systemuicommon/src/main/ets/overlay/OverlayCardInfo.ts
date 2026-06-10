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

import { RectInfo } from '@ohos/basicutils';
import { OverlayCardInterface, OverlayCardStateInterface } from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import { CommonUtils } from '@ohos/basicutils';
import ComponentSnapshot from '@ohos.arkui.componentSnapshot';
import type Image from '@ohos.multimedia.image';
import { LiveCapsuleData } from '../liveview/data/capsule/LiveCapsuleData';
import { CapsuleAnimStyle } from '../liveview/info/capsule/CapsuleAnimStyle';
import curves from '@ohos.curves';


/**
 * 等待截图
 */
type SnapshotResolve = (snapshot: Image.PixelMap | PromiseLike<Image.PixelMap>) => void;

const bezierX: number = 0.2;

/**
 * 动效类型
 */
export enum OverlayAnimType {
  /**
   * 点击卡片启动应用
   */
  TYPE_START_APP = 1,

  /**
   * 应用退出到胶囊
   */
  TYPE_EXIT_CAPSULE = 2,
}

/**
 * 动效场景
 */
export enum OverlayAnimScene {
  /**
   * 点击图标启动应用一镜到底
   * 应用窗口先缩放(scale)到图标大小，并移动到图标位置，再逐渐恢复到原始应用窗口大小和位置
   * 当前用于控制中心点击设置按钮打开设置窗口一镜到底动效
   * 同类动效都可使用该类型，并可自定义动效参数
   */
  TYPE_START_APP_FROM_ICON = 1,

  /** 从通知卡片启动 */
  TYPE_START_APP_FROM_NTF_CENTER = 2,

  /**
   * 点击锁屏通知启动卡片一镜到底动效
   */
  TYPE_START_APP_FROM_LOCK_SCREEN = 3
}

/**
 * overlay动效参数配置
 */
export interface OverlayAnimParam {
  /**
   * 动效时长
   */
  duration?: number;

  /**
   * 动效曲线
   */
  curve: Curve | string | ICurve;

  /**
   * 动效延时
   */
  delay?: number;
}

/**
 * 卡片圆角
 */
export interface CardBorderRadius {
  topLeft: number;
  topRight: number;
  bottomLeft: number;
  bottomRight: number
}

/**
 * overlay卡片信息接口
 */
export interface IOverlayCard {
  /**
   * 卡片背景组件ID，必传
   */
  cardBgId: string;

  /**
   * 卡片内容组件ID，必传
   */
  cardContentId: string;

  /**
   * 启动应用包名，必传
   */
  startBundleName: string;

  /**
   * 面板层级，必传
   */
  oriPanelZIndex: number;

  /**
   * 是否启用背景卡片组件布局
   */
  isShowCardBg?: boolean;

  /**
   * 卡片背景颜色
   */
  cardBgColor?: ResourceColor;

  /**
   * 卡片背景高亮度
   */
  cardBgBrightness?: number;

  /**
   * 卡片背景饱和度
   */
  cardBgSaturate?: number;

  /**
   * 卡片背景模糊样式
   */
  cardBgBlurStyle?: BlurStyle;

  /**
   * 卡片背景模糊半径
   */
  cardBgBackdropBlur?: number;

  /**
   * 卡片圆角
   */
  cardRadius?: CardBorderRadius;

  /**
   * 卡片位置信息, 若指定则以该位置为准
   */
  cardPosition?: RectInfo;

  /**
   * 卡片内容位置
   */
  cardContentPosition?: RectInfo;

  /**
   * 动效启动回调
   */
  onAnimActive?: () => void;

  /**
   * 动效结束回调
   */
  onAnimInactive?: () => void;

  /**
   * 动效取消回调
   */
  onAnimCanceled?: () => void;

  /**
   * 启动应用面板缩放和位置动效参数
   */
  sceneSizeAndPositionAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板圆角动效参数
   */
  sceneBorderRadiusAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板蒙层颜色动效参数
   */
  sceneMaskColorAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板透明度动效参数
   */
  sceneAlphaAnimParam?: OverlayAnimParam;

  /**
   * 图标的透明度动效参数
   */
  iconAlphaAnimParam?: OverlayAnimParam;

  /**
   * 应用启动动效类型
   */
  animType?: OverlayAnimType;

  /**
   * 动效场景
   */
  animScene?: OverlayAnimScene;

  /**
   * 卡片内容资源
   */
  cardResource?: Resource;
}

/**
 * overlay卡片数据信息
 */
export class OverlayCardInfo extends OverlayCardInterface {

  /**
   * 是否启用卡片背景组件，默认启用
   */
  isShowCardBg: boolean = true;

  /**
   * 卡片背景颜色
   */
  cardBgColor: ResourceColor;

  /**
   * 卡片内容资源
   */
  cardResource?: Resource;

  /**
   * 卡片模糊半径
   */
  cardEffectRadius: number = 0;

  /**
   * 卡片背景高亮度，默认正常1.0
   */
  cardBgBrightness: number = 1.0;

  /**
   * 卡片背景饱和度，默认正常1.0
   */
  cardBgSaturate: number = 1.0;

  /**
   * 卡片背景模糊样式
   */
  cardBgBlurStyle: BlurStyle;

  /**
   * 卡片背景模糊半径
   */
  cardBgBackdropBlur: number;

  /**
   * 卡片圆角
   */
  cardRadius: CardBorderRadius = {
    topLeft: 0,
    topRight: 0,
    bottomLeft: 0,
    bottomRight: 0
  };

  /**
   * 原面板层级
   */
  oriPanelZIndex: number = 0;

  /**
   * 状态栏层级变化动效
   */
  static statusBarAnimParam: OverlayAnimParam = {
    duration: 30,
    curve: Curve.Linear,
    delay: 0
  };

  /**
   * 启动应用面板动效
   */
  static sceneAnimParam: OverlayAnimParam = {
    duration: 400,
    curve: curves.cubicBezierCurve(bezierX, 0, bezierX, 1),
    delay: 0
  };

  /**
   * overlay卡片alpha动效
   */
  static cardAlphaAnimParam: OverlayAnimParam = {
    duration: 80,
    curve: Curve.Linear,
    delay: 0
  };

  /**
   * 启动应用面板透明度动效
   */
  static sceneAlphaAnimParam: OverlayAnimParam = {
    duration: 150,
    curve: Curve.Smooth,
    delay: 0
  };

  static cardAlphaAnimParamFromLockScreen: OverlayAnimParam = {
    duration: 150,
    curve: Curve.Smooth,
    delay: 0
  };

  /**
   * 启动应用面板缩放和位置动效参数
   */
  sceneSizeAndPositionAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板圆角动效参数
   */
  sceneBorderRadiusAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板蒙层颜色动效参数
   */
  sceneMaskColorAnimParam?: OverlayAnimParam;

  /**
   * 启动应用面板透明度动效参数
   */
  sceneAlphaAnimParam?: OverlayAnimParam;

  /**
   * 图标的透明度动效参数
   */
  iconAlphaAnimParam?: OverlayAnimParam;

  /**
   * overlay组件层级，默认悬浮在应用页面上面
   */
  overlayComponentZIndex: number = 1;

  /**
   * 实况胶囊数据
   */
  capsuleData?: LiveCapsuleData;

  /**
   * 实况胶囊动效样式
   */
  capsuleStyle?: CapsuleAnimStyle;

  /**
   * 动效类型，默认启动应用
   */
  animType: OverlayAnimType = OverlayAnimType.TYPE_START_APP;

  /**
   * 动效场景
   */
  animScene?: OverlayAnimScene;

  /**
   * 原卡片组件的标识ID
   * 用于卡片背景位置定位
   */
  readonly oriCardBgId?: string;

  /**
   * 原卡片组件的标识ID
   * 用于卡片内用位置定位、截图
   */
  readonly oriCardContentId?: string;

  /**
   * 卡片当前缩放值
   */
  readonly cardScaleX: number = 1.0;

  /**
   * 卡片当前缩放值
   */
  readonly cardScaleY: number = 1.0;

  /**
   * 卡片背景位置
   */
  readonly cardBgPosition: RectInfo = new RectInfo();

  /**
   * 卡片内容位置
   */
  readonly cardContentPosition: RectInfo = new RectInfo();

  /**
   * 卡片内容截图
   */
  private cardSnapshot: Image.PixelMap;

  /**
   * 截图是否加载完成
   */
  private isLoadComplete: boolean = false;

  /**
   * 等待截图
   */
  private snapshotResolve: SnapshotResolve;

  /**
   * 动效开始对应的处理
   */
  onAnimActive?: () => void;

  /**
   * 动效结束对应的处理
   */
  onAnimInactive?: () => void;

  /**
   * 动效取消回调
   */
  onAnimCanceled?: () => void;

  /**
   * 构造
   *
   * @param cardBgId 卡片背景组件ID
   * @param cardContentId 卡片内容组件ID
   */
  constructor(animType?: OverlayAnimType, cardBgId?: string, cardContentId?: string) {
    super();
    if (animType) {
      this.animType = animType;
    }
    this.oriCardBgId = cardBgId;
    this.oriCardContentId = cardContentId;

    // 缩放以背景组件的缩放值为准
    if (cardBgId) {
      this.cardBgPosition = ItemUtils.getRectById(cardBgId);
      let scaleResult = ItemUtils.getScaleById(cardBgId);
      if (!CommonUtils.isInvalid(scaleResult)) {
        this.cardScaleX = scaleResult.x;
        this.cardScaleY = scaleResult.y;
      }
    }

    // 加载卡片内容截图
    if (cardContentId) {
      this.cardContentPosition = ItemUtils.getRectById(cardContentId);
      ComponentSnapshot.get(cardContentId).then((snapshot) => {
        this.cardSnapshot = snapshot;
        this.isLoadComplete = true;
        this.resolveSnapshot();
      })
        .catch((reason) => {
          // 加载失败
          this.isLoadComplete = true;
          this.resolveSnapshot();
        });
    } else {
      this.isLoadComplete = true;
    }
  }

  /**
   * 设置卡片背景位置
   *
   * @param position 位置
   */
  setCardBgPosition(position: RectInfo): void {
    if (this.cardBgPosition) {
      this.cardBgPosition.top = position?.top ?? 0;
      this.cardBgPosition.bottom = position?.bottom ?? 0;
      this.cardBgPosition.left = position?.left ?? 0;
      this.cardBgPosition.right = position?.right ?? 0;
    }
  }

  /**
   * 设置卡片内容位置
   *
   * @param position 位置
   */
  setCardContentPosition(position: RectInfo): void {
    if (this.cardContentPosition) {
      this.cardContentPosition.top = position?.top ?? 0;
      this.cardContentPosition.bottom = position?.bottom ?? 0;
      this.cardContentPosition.left = position?.left ?? 0;
      this.cardContentPosition.right = position?.right ?? 0;
    }
  }

  /**
   * 是否启动应用动效
   *
   * @returns true启动应用动效
   */
  isTypeStartApp(): boolean {
    return this.animType === OverlayAnimType.TYPE_START_APP;
  }

  /**
   * 是否应用退出到胶囊
   *
   * @returns true应用退出到胶囊
   */
  isTypeExitCapsule(): boolean {
    return this.animType === OverlayAnimType.TYPE_EXIT_CAPSULE;
  }

  /**
   * 是否点击图标打开应用一镜到底动效
   *
   * @returns true 点击图标一镜到底动效
   */
  isStartFromIcon(): boolean {
    return this.animScene === OverlayAnimScene.TYPE_START_APP_FROM_ICON;
  }

  isStartFromNtfCenter(): boolean {
    return this.animScene === OverlayAnimScene.TYPE_START_APP_FROM_NTF_CENTER;
  }

  isStartFromLockScreen(): boolean {
    return this.animScene === OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN;
  }

  /**
   * 获取卡片背景宽度
   *
   * @returns 背景宽度
   */
  getBgWidth(): number {
    return this.cardBgPosition.right - this.cardBgPosition.left;
  }

  /**
   * 获取卡片背景高度
   *
   * @returns 背景高度
   */
  getBgHeight(): number {
    return this.cardBgPosition.bottom - this.cardBgPosition.top;
  }

  /**
   * 获取卡片内容宽度
   *
   * @returns 卡片宽度
   */
  getContentWidth(): number {
    return this.cardContentPosition.right - this.cardContentPosition.left;
  }

  /**
   * 获取卡片内容高度
   *
   * @returns 卡片高度
   */
  getContentHeight(): number {
    return this.cardContentPosition.bottom - this.cardContentPosition.top;
  }

  /**
   * 获取卡片内容相对于卡片背景的位置偏移
   *
   * @returns X偏移
   */
  getContentPositionX(): number {
    return this.cardContentPosition.left - this.cardBgPosition.left;
  }

  /**
   * 获取卡片内容相对于卡片背景的位置偏移
   *
   * @returns Y偏移
   */
  getContentPositionY(): number {
    return this.cardContentPosition.top - this.cardBgPosition.top;
  }

  /**
   * 获取卡片内容截图
   *
   * @returns 卡片内容截图
   */
  async getContentSnapshot(): Promise<Image.PixelMap> {
    if (this.isLoadComplete) {
      return this.cardSnapshot;
    }
    return new Promise((resolve) => {
      this.snapshotResolve = resolve;
    });
  }

  /**
   * 数据转换
   *
   * @param card 卡片数据
   */
  castFromCard(card: IOverlayCard): void {
    this.startBundleName = card.startBundleName;
    this.oriPanelZIndex = card.oriPanelZIndex;
    this.castAnimParam(card);
    if (!CommonUtils.isInvalid(card.isShowCardBg)) {
      this.isShowCardBg = card.isShowCardBg;
    }
    if (!CommonUtils.isInvalid(card.cardBgColor)) {
      this.cardBgColor = card.cardBgColor;
    }
    if (!CommonUtils.isInvalid(card.cardBgBrightness)) {
      this.cardBgBrightness = card.cardBgBrightness;
    }
    if (!CommonUtils.isInvalid(card.cardBgSaturate)) {
      this.cardBgSaturate = card.cardBgSaturate;
    }
    if (!CommonUtils.isInvalid(card.cardBgBlurStyle)) {
      this.cardBgBlurStyle = card.cardBgBlurStyle;
    }
    if (!CommonUtils.isInvalid(card.cardBgBackdropBlur)) {
      this.cardBgBackdropBlur = card.cardBgBackdropBlur;
    }
    if (!CommonUtils.isInvalid(card.cardRadius)) {
      this.cardRadius = card.cardRadius;
    }
    if (!CommonUtils.isInvalid(card.animScene)) {
      this.animScene = card.animScene;
    }
    if (!CommonUtils.isInvalid(card.animType)) {
      this.animType = card.animType;
    }
    if (!CommonUtils.isInvalid(card.onAnimActive)) {
      this.onAnimActive = card.onAnimActive;
    }
    if (!CommonUtils.isInvalid(card.onAnimInactive)) {
      this.onAnimInactive = card.onAnimInactive;
    }
    if (!CommonUtils.isInvalid(card.onAnimCanceled)) {
      this.onAnimCanceled = card.onAnimCanceled;
    }
    if (!CommonUtils.isInvalid(card.animScene)) {
      this.animScene = card.animScene;
      if (this.isStartFromNtfCenter()) {
        this.isShowOverlayComponent = false;
      }
    }
  }

  private castAnimParam(card: IOverlayCard): void {
    if (!CommonUtils.isInvalid(card.sceneSizeAndPositionAnimParam)) {
      this.sceneSizeAndPositionAnimParam = card.sceneSizeAndPositionAnimParam;
    }
    if (!CommonUtils.isInvalid(card.sceneBorderRadiusAnimParam)) {
      this.sceneBorderRadiusAnimParam = card.sceneBorderRadiusAnimParam;
    }
    if (!CommonUtils.isInvalid(card.sceneMaskColorAnimParam)) {
      this.sceneMaskColorAnimParam = card.sceneMaskColorAnimParam;
    }
    if (!CommonUtils.isInvalid(card.sceneAlphaAnimParam)) {
      this.sceneAlphaAnimParam = card.sceneAlphaAnimParam;
    }
    if (!CommonUtils.isInvalid(card.iconAlphaAnimParam)) {
      this.iconAlphaAnimParam = card.iconAlphaAnimParam;
    }
  }

  /**
   * 设置卡片圆角
   *
   * @param radius 圆角
   */
  setCardRadius(radius: number): void {
    this.cardRadius.topLeft = radius;
    this.cardRadius.topRight = radius;
    this.cardRadius.bottomLeft = radius;
    this.cardRadius.bottomRight = radius;
  }

  setCardResource(cardResource: Resource): void {
    this.cardResource = cardResource;
  }

  /**
   * 回调卡片截图
   */
  private resolveSnapshot(): void {
    if (CommonUtils.isInvalid(this.snapshotResolve)) {
      return;
    }
    this.snapshotResolve(this.cardSnapshot);
    this.snapshotResolve = null;
  }
}

/**
 * overlay卡片动效属性状态
 */
@Observed
export class OverlayCardState extends OverlayCardStateInterface {
  /**
   * overlay卡片背景组件透明度
   */
  overlayCardBgAlpha: number = 1.0;

  /**
   * overlay卡片内容组件透明度
   */
  overlayCardAlpha: number = 1.0;

  /**
   * overlay卡片内容组件终点位移X
   */
  overlayCardEndTranX: number = 0;

  /**
   * overlay卡片内容组件终点位移Y
   */
  overlayCardEndTranY: number = 0;

  /**
   * overlay卡片内容缩放X
   */
  overlayCardScaleX: number = 1.0;

  /**
   * overlay卡片内容缩放Y
   */
  overlayCardScaleY: number = 1.0;

  /**
   * 面板容器位移X
   */
  containerTranX: number = 0;

  /**
   * 面板容器位移Y
   */
  containerTranY: number = 0;

  /**
   * 面板宽度
   */
  containerWidth?: number;

  /**
   * 面板高度
   */
  containerHeight?: number;

  /**
   * icon大小
   */
  iconWidth?: number;
}