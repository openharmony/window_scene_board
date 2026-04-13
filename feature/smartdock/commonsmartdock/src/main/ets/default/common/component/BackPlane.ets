/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { layoutConfigManager } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import FeatureConstants from '../constants/FeatureConstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { curves } from '@kit.ArkUI';
import { EvtBus, DockAvgColorChangeEvent, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SmartDockStyleConfig } from '../SmartDockStyleConfig';
import { DockRegionLayoutModel } from '../../model/DockRegionLayoutModel';


const TAG = 'BackPlane';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


/**
 * BackPlane
 *
 * @since 2023-11-10
 */
@Component
export default struct BackPlane {
  mBackSaturation: number = 0;
  backPlaneId: string = '';
  backPlaneUseEffect: boolean = true;
  private verticalBgColor: string | undefined;
  private backPlaneChangeListener: (data: DockAvgColorChangeEvent) => void = (data: DockAvgColorChangeEvent) => {
    log.showInfo(`WallpaperColorManager backPlaneChangeListener,${data.dockAvgColor}`);
    if (data.isWallpaperChange) {
      this.verticalBgColor = undefined;
    }
    this.onBackPlaneBgColorChange(data.dockAvgColor);
  };
  @StorageLink('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @Prop mDockHeight: number = 0;
  @Prop mDockRadius: number = 0;
  @Prop backPlaneWidth: number | string = '';
  @Prop backPlaneTranslate: TranslateOptions = {};
  @Prop backPlaneScale: ScaleOptions = {};
  @Prop backPlaneOpacity: number = 1;
  @Prop backPlaneVisibility: Visibility = Visibility.Visible;
  @Prop backPlaneBlur: number = 0;
  @State bgColor: string | undefined = WallpaperColorManager.getInstance().getBackPlaneColor();

  async onPortraitChange(): Promise<void> {
    log.showInfo(` onPortraitChange ${this.mIsPortrait}`);
    this.initConfig();
    if (SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.DOCK_BLUR_DISABLE)) {
      if (this.verticalBgColor) {
        let temp: string | undefined = this.bgColor
        this.bgColor = this.verticalBgColor;
        this.verticalBgColor = temp;
      } else {
        this.verticalBgColor = this.bgColor;
        this.updateBackPlaneColor();
      }
    }
  }

  onBackPlaneBgColorChange(bgColor: string): void {
    animateTo({
      duration: 300,
      delay: 0,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    }, () => {
      this.bgColor = bgColor;
    })
  }

  private initConfig() {
    let mSmartDockStyleConfig: SmartDockStyleConfig = layoutConfigManager.getStyleConfig(
      SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME)
    this.mDockHeight = DockRegionLayoutModel.getInstance().getDockHeight();
    this.mDockRadius = DockRegionLayoutModel.getInstance().getDockRadius();
    this.mBackSaturation = mSmartDockStyleConfig.mBackSaturation;
  }

  async aboutToAppear(): Promise<void> {
    log.showInfo('aboutToAppear, backplaneWidth:' + this.backPlaneWidth);
    this.initConfig();
    this.backPlaneUseEffect = !SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.DOCK_BLUR_DISABLE);
    EvtBus.on(DockAvgColorChangeEvent, this.backPlaneChangeListener);
    if (SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.DOCK_BLUR_DISABLE) &&
      !WallpaperColorManager.getInstance().getBackPlaneColor()) {
      this.updateBackPlaneColor();
    }
  }

  async updateBackPlaneColor(): Promise<void> {
    await WallpaperColorManager.getInstance().handleDockBackPlaneColor();
    EvtBus.post(DockAvgColorChangeEvent,
      { dockAvgColor: WallpaperColorManager.getInstance().getBackPlaneColor(), isWallpaperChange: false });
  }

  aboutToDisappear(): void {
    EvtBus.off(DockAvgColorChangeEvent, this.backPlaneChangeListener);
  }

  build() {
    Row()
      .id(this.backPlaneId)
      .height(this.mDockHeight)
      .width(this.backPlaneWidth)
      .border(SCBSceneSessionManager.getInstance().isPcMode() ? {
        radius: this.mDockRadius,
        width: { top: 1, right: 1, bottom: 1, left: 1 },
        color: '#1A000000',
        style: BorderStyle.Solid
      } : {
        radius: this.mDockRadius,
        color: Color.Transparent
      })
      .translate(this.backPlaneTranslate)
      .scale(this.backPlaneScale)
      .opacity(this.backPlaneOpacity)
      .visibility(this.backPlaneVisibility)
      .useEffect(this.backPlaneUseEffect)
      .backgroundColor(this.bgColor)
  }
}
