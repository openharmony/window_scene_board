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
import MemoryCacheTest from './base/cache/MemoryCache.test';
import PreferenceApiTest from './base/cache/PreferenceApi.test';
import PreferenceStoreCacheTest from './base/cache/PreferenceStoreCache.test';
import TsLogTest from './base/log/TsLog.test';
import OnlineThemeInfoTest from './base/remote/OnlineThemeInfo.test';
import ParamInspectorTest from './base/remote/ParamInspector.test';
import RpcCodecTest from './base/remote/RpcCodec.test';
import TrustCallerInterceptorTest from './base/remote/TrustCallerInterceptor.test';
import ServiceRegisterTest from './base/service/ServiceRegister.test';
import SingletonTest from './base/service/Singleton.test';
import ArrayUtilsTest from './base/util/ArrayUtils.test';
import FileUtilTest from './base/util/FileUtil.test';
import { JsonTransformerTest, JsonUtilsTestParse, JsonUtilsTestStringify } from './base/util/JsonUtils.test';
import MapUtilsTest from './base/util/MapUtils.test';
import ObjectUtilsTest from './base/util/ObjectUtils.test';
import StringUtilsTest from './base/util/StringUtils.test';
import ActivateThemeStyleTest from './core/api/ActivateThemeStyle.test';
import ApplyAodTest from './core/api/ApplyAod.test';
import ApplyConfigTest from './core/api/ApplyConfig.test';
import ApplyFontTest from './core/api/ApplyFont.test';
import ApplyIconsTest from './core/api/ApplyIcons.test';
import DeleteOnlineThemeTest from './core/api/DeleteOnlineTheme.test';
import GetFontTest from './core/api/GetFont.test';
import GetThemeListTest from './core/api/GetThemeList.test';
import GlobalPersistTest from './core/api/GlobalPersist.test';
import HostedThemeDownloadedTest from './core/api/HostedThemeDownloaded.test';
import LimitedFreeThemeTest from './core/api/LimitedFreeTheme.test';
import OnlineRecommendTest from './core/api/OnlineRecommend.test';
import RemoveThemeTest from './core/api/RemoveTheme.test';
import ResetServiceTest from './core/api/ResetService.test';
import SetCurrentThemeCfgTest from './core/api/SetCurrentThemeCfg.test';
import SetSkinTest from './core/api/SetSkin.test';
import SetWallPaperTest from './core/api/SetWallPaper.test';
import ThemeApplyServiceTest from './core/api/ThemeApplyService.test';
import ThemeAppStatusServiceTest from './core/api/ThemeAppStatusService.test';
import ThemeMixedExecutorTest from './core/api/ThemeMixedExecutor.test';
import ThemeTrialServiceTest from './core/api/ThemeTrialService.test';
import ThemeVipServiceTest from './core/api/ThemeVipService.test';
import TsTimerTest from './core/api/TsTimer.test';
import UpdateThemeInfoServiceTest from './core/api/UpdateThemeInfoService.test';
import WallpaperBlurHandlerTest from './core/api/WallpaperBlurHandler.test';
import ThemePackCacheTest from './core/cache/ThemePackCache.test';
import ThemeTrialCacheTest from './core/cache/ThemeTrialCache.test';
import ThemePackParserTest from './core/preset/ThemePackParser.test';
import GetThemeInfoInnerTest from './core/service/GetThemeInfoInner.test';
import UpgradeServiceTest from './core/service/UpgradeService.test';
import CommonEventTest from './core/util/CommonEvent.test';
import PathValidateUtilTest from './core/util/PathValidateUtil.test';
import PixelMapUtilTest from './core/util/PixelMapUtil.test';
import ThemeOptionsTest from './inner_api/model/ThemeOptions.test';
import VersionInfoTest from './inner_api/model/VersionInfo.test';
import LoggerTest from './kit/Logger.test';
import TsCurrentThemeTest from './kit/TsCurrentTheme.test';
import TSManagerTest from './kit/TSManager.test';

export default function ThemeServiceTestsuite() {
  ThemePackParserTest();
  TSManagerTest();
  GetFontTest();
  SetSkinTest();
  ActivateThemeStyleTest();
  ThemePackCacheTest();
  OnlineRecommendTest();
  GetThemeListTest();
  SetWallPaperTest();
  ResetServiceTest();
  DeleteOnlineThemeTest();
  RemoveThemeTest();
  HostedThemeDownloadedTest();
  ThemeApplyServiceTest();
  GlobalPersistTest();
  UpdateThemeInfoServiceTest();

  UpgradeServiceTest();

  GetThemeInfoInnerTest();
  MemoryCacheTest();
  PreferenceStoreCacheTest();
  PreferenceApiTest();

  TsLogTest();
  ThemeOptionsTest();
  RpcCodecTest();
  TrustCallerInterceptorTest();
  JsonUtilsTestParse();
  JsonUtilsTestStringify();
  JsonTransformerTest();
  SingletonTest();
  StringUtilsTest();
  ObjectUtilsTest();
  ArrayUtilsTest();
  MapUtilsTest();
  ServiceRegisterTest();
  ParamInspectorTest();

  PixelMapUtilTest();
  ThemeAppStatusServiceTest();
  ThemeTrialCacheTest();
  ThemeMixedExecutorTest();
  TsTimerTest();
  ThemeTrialServiceTest();
  OnlineThemeInfoTest();
  ThemeVipServiceTest();
  PathValidateUtilTest();
  FileUtilTest();
  VersionInfoTest();
  LoggerTest();
  WallpaperBlurHandlerTest();
  ApplyAodTest();
  LimitedFreeThemeTest();
  ApplyConfigTest();
  ApplyFontTest();
  ApplyIconsTest();
  SetCurrentThemeCfgTest();
  CommonEventTest();
  TsCurrentThemeTest();
}
