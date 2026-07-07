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

import { desktopUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { common } from '@kit.AbilityKit';
import lottie, { AnimationItem } from '@ohos/lottie';
import util from '@ohos.util';
import { ThreeButtonUpgradeData, ThreeButtonUpgradeViewData } from './ThreeButtonUpgradeViewData';
import { ThreeButtonUpgradeConstants, ThreeButtonUpgradeParam } from '../ThreeButtonUpgradeConstants';
import { display } from '@kit.ArkUI';
import { AiBarSettingsDataMgr } from '../settings/preference/AiBarSettingsDataMgr';
import { SwitchType } from '../settings/preference/PreferenceType';

const TAG = 'ThreeButtonUpgradeViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 三键导航升级向导viewModel
 */
export class ThreeButtonUpgradeViewModel {
  private upgradeData: ThreeButtonUpgradeData;
  private upgradeViewData: ThreeButtonUpgradeViewData;

  constructor(upgradeData: ThreeButtonUpgradeData, upgradeViewData: ThreeButtonUpgradeViewData) {
    this.upgradeData = upgradeData;
    this.upgradeViewData = upgradeViewData;
  }

  /**
   * 三键导航升级向导初始化
   */
  public aboutToAppear(): void {
    for (let swiperItem of this.upgradeViewData.swiperItems) {
      log.showInfo(`init CanvasRenderingContext2D index is ${swiperItem.index}`);
      this.upgradeViewData.renderingContexts[swiperItem.index] =
        new CanvasRenderingContext2D(this.upgradeData.renderingSettings);
    }
    this.initUpgradeParam(display.getFoldDisplayMode());
    this.initScreenParam();
    this.calculateUpgradeParam(this.upgradeData.upgradeParam);
    this.updateLottie(this.upgradeData.upgradeParam.jsonPrefix);
    // 注册屏幕参数变化
    this.monitorFoldStatus();
    // 点击返回按钮默认打开
    AiBarSettingsDataMgr.getInstance().putValue(SwitchType.CLICK_BACK_STATUS, 'true');
  }

  private monitorFoldStatus(): void {
    try {
      display.on('foldDisplayModeChange', (foldDisplayMode: display.FoldDisplayMode) => {
        log.showInfo(`foldDisplayModeChange ${foldDisplayMode}`);
        this.initScreenParam();
        this.initUpgradeParam(foldDisplayMode);
        this.calculateUpgradeParam(this.upgradeData.upgradeParam);
        this.updateLottie(this.upgradeData.upgradeParam.jsonPrefix);
      })
    } catch (error) {
      log.showError(`on foldDisplayModeChange error ${error}`);
    }
  }

  private initScreenParam(): void {
    try {
      this.upgradeData.screenWidth = px2vp(display.getDefaultDisplaySync().width);
      this.upgradeData.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    } catch (error) {
      log.showError(`getDefaultDisplaySync error ${error}`);
    }
  }

  private initUpgradeParam(foldDisplayMode: display.FoldDisplayMode): void {
    if (DeviceHelper.isPad()) {
      // 按照平板逻辑处理
      this.upgradeData.upgradeParam = ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_PAD_PARAM;
      log.showInfo('initUpgradeParam pad');
      return;
    }
    if (!desktopUtil.isFold() || (foldDisplayMode !== display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL)) {
      // 按照直版机逻辑处理
      this.upgradeData.upgradeParam = ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_PHONE_PARAM;
      log.showInfo('initUpgradeParam phone');
    } else {
      // 按照折叠屏展开态逻辑处理
      this.upgradeData.upgradeParam = ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_FOLD_PARAM;
      log.showInfo('initUpgradeParam fold');
    }
  }

  private calculateUpgradeParam(upgradeParam: ThreeButtonUpgradeParam): void {
    this.upgradeViewData.horizontal = upgradeParam.horizontal;
    this.upgradeViewData.swiperHeight = this.upgradeData.screenHeight - ThreeButtonUpgradeConstants.SWIPER_TOP_MARGIN -
    ThreeButtonUpgradeConstants.SWIPER_BOTTOM_MARGIN - ThreeButtonUpgradeConstants.BUTTON_HEIGHT -
    ThreeButtonUpgradeConstants.BUTTON_BOTTOM_MARGIN;

    // 计算单个栅格宽度
    const gridWidth: number = (this.upgradeData.screenWidth - (upgradeParam.sinkNumber *
    ThreeButtonUpgradeConstants.SINK_WIDTH)) / upgradeParam.gridNumber;
    this.upgradeViewData.swiperWidth = gridWidth * upgradeParam.swiperOccupyGridNumber +
      ThreeButtonUpgradeConstants.SINK_WIDTH * upgradeParam.swiperOccupySinkNumber;
    this.upgradeViewData.buttonWidth = gridWidth * upgradeParam.buttonOccupyGridNumber +
      ThreeButtonUpgradeConstants.SINK_WIDTH * upgradeParam.buttonOccupySinkNumber;
    this.upgradeViewData.canvasSize = gridWidth * upgradeParam.lottieOccupyGridNumber +
      ThreeButtonUpgradeConstants.SINK_WIDTH * upgradeParam.lottieOccupySinkNumber;
    this.upgradeViewData.lottieMoveUpDistance = this.upgradeViewData.canvasSize * upgradeParam.lottieMoveUpScale;
  }

  /**
   * 重置lottie资源名称
   * @param jsonPrefix 资源名称前缀
   */
  public updateLottie(jsonPrefix: string) {
    for (let swiperItem of this.upgradeViewData.swiperItems) {
      let swiperItemName = ThreeButtonUpgradeConstants.SWIPER_ITEM_NAME[swiperItem.index];
      swiperItem.name = jsonPrefix + swiperItemName;
      log.showInfo(`swiperItemName: ${swiperItemName}, jsonPrefix: ${jsonPrefix}`);
    }
  }

  /**
   * 加载lottie动效
   * @param index 要加载的lottie动效列表索引
   */
  public playLottie(index: number) {
    let resStr = new util.TextDecoder('utf-8', { ignoreBOM: true });
    let item = this.upgradeViewData.swiperItems[index];
    try {
      let jsonName: string = this.upgradeViewData.swiperItems[item.index].name;
      let swiperItemName = ThreeButtonUpgradeConstants.SWIPER_ITEM_NAME[index];
      let context = getContext(this) as common.UIAbilityContext;
      context.resourceManager.getRawFileContent(jsonName, (err: Error, data: Uint8Array) => {
        if (!data?.buffer) {
          log.showError(`getRawFileContent error is: ${err.message}`);
          return;
        }
        this.upgradeViewData.animationData = JSON.parse(resStr.decode(new Uint8Array(data.buffer)));
        log.showInfo(`loadLottieData, lottieData: %{public}s`, this.upgradeViewData.swiperItems[item.index].name);
        //加载动画前先销毁之前加载的动画
        lottie.destroy(swiperItemName);
        log.showInfo(`loadAnimation name: ${swiperItemName}`);
        this.upgradeViewData.lottieItems[index] = lottie.loadAnimation({
          container: this.upgradeViewData.renderingContexts[item.index],
          renderer: 'canvas',
          loop: true,
          autoplay: true,
          name: swiperItemName,
          contentMode: 'Contain',
          frameRate: 30,
          animationData: this.upgradeViewData.animationData,
        });
        this.addEventListener(index, this.upgradeViewData.lottieItems[index]);
      });
    } catch (error) {
      log.showError(`context is undefined, message is ${error}`);
    }
  }

  private addEventListener(index: number, animateItem: AnimationItem) {
    animateItem.addEventListener('loopComplete', (args: Object): void => {
      log.showInfo(`add loopComplete lottie index: ${index}`);
    });
    animateItem.addEventListener('complete', (args: Object): void => {
      log.showInfo(`add complete lottie index: ${index}`);
    });
    animateItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`add destroy lottie index: ${index}`);
    });
    animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(`loopComplete lottie index: ${index}`);
    });
  }

  /**
   * 关闭页面及缩放资源
   */
  public closeSelf(): void {
    try {
      display.off('foldDisplayModeChange');
      let data: Record<string, Object> = {
        'want': GlobalContext.getInstance().getObject(ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_WANT) as object,
        'resultCode': 100
      }
      this.upgradeData?.session?.sendData(data);
      log.showInfo('close ThreeButtonUpgradeView');
    } catch (error) {
      log.showError(`closeSelf error： ${error}`);
    }
  }

  /**
   * swiper 翻页开始
   * @param index 要加载的swiper页索引
   */
  public swiperChangeStart(index: number): void {
    const animateItem: AnimationItem | null = this.upgradeViewData.lottieItems[index];
    if (animateItem) {
      log.showInfo(`swiperChangeStart index is ${index}`);
      animateItem.goToAndStop(0, true);
    }
  }

  /**
   * swiper 翻页结束
   * @param index 要加载的swiper页索引
   */
  public swiperChangeEnd(index: number): void {
    const animateItem: AnimationItem | null = this.upgradeViewData.lottieItems[index];
    if (animateItem) {
      log.showInfo(`swiperChangeEnd index is ${index}`);
      animateItem.play();
    }
  }

  /**
   * 设置按钮透明度
   * @param index 要加载的swiper页索引
   */
  public setButtonOpacity(index: number): void {
    log.showInfo(`setNeedShowButton index is ${index}, swiperItemsLength: ${this.upgradeViewData.swiperItems.length}`);
    if (this.upgradeViewData.buttonOpacity === 1) {
      return;
    }
    if ((index + 1) >= this.upgradeViewData.swiperItems.length) {
      this.upgradeViewData.buttonOpacity = 1;
    }
  }
}