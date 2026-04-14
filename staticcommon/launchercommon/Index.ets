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

/**
 * 该文件只用于导出ets文件，导出ts文件要放到 launchercommon/src/main/ets/TsIndex.ts。
 */
export { FolderItemAnimateData } from './src/main/ets/folder/data/FolderItemAnimateData';

export { FolderServiceManager } from './src/main/ets/folder/model/FolderServiceManager';

export { ItemAnimationParams } from './src/main/ets/animation/ItemAnimationParams';

export { nameAppearAnimate } from './src/main/ets/animation/LauncherAnimation';

export { ViewManager } from './src/main/ets/manager/ViewManager';

export { CustomBadge } from './src/main/ets/uicomponents/CustomBadge';

export { AppMenu } from './src/main/ets/uicomponents/AppMenu';

export { CompanionIcon } from './src/main/ets/uicomponents/CompanionIcon';

export { RemoveFormDialog } from './src/main/ets/uicomponents/RemoveFormDialog';

export { UninstallDialog } from './src/main/ets/uicomponents/UninstallDialog';

export { ReConfirmationUninstallDialog } from './src/main/ets/uicomponents/ReConfirmationUninstallDialog';

export { FormBaseComponent } from './src/main/ets/form/view/FormBaseComponent';

export { FormComponentEvent } from './src/main/ets/form/viewmodel/FormComponentEvent';

export { FormComponentVm } from './src/main/ets/form/viewmodel/FormComponentVm';

export { FormComponentModel } from './src/main/ets/form/model/FormComponentModel';

export { FormLine } from './src/main/ets/uicomponents/FormLine';

export { RunningTask } from './src/main/ets/uicomponents/RunningTask';

export { default as FormMenu } from './src/main/ets/uicomponents/FormMenu';

export { LazyDataSource } from './src/main/ets/uicomponents/LazyDataSource';

export { BadgeAnimationType } from './src/main/ets/uicomponents/CustomBadge';

export { default as MultiFingerPinchUtil } from './src/main/ets/utils/MultiFingerPinchUtil';

export { LongPressAppIconInfo } from './src/main/ets/bean/LongPressAppIconInfo';

export { AppIconModel } from './src/main/ets/launchericon/common/AppIconModel';

export { AppName, AppNameModifier } from './src/main/ets/uicomponents/AppName';

export { AddIconComponent } from './src/main/ets/folder/AddIconComponent';

export { FolderViewData, ItemEffectParam} from './src/main/ets/folder/FolderViewData';

export { BaseNodeManager } from './src/main/ets/buildernode/BaseNodeManager';

export { dragTriggerUtil } from './src/main/ets/utils/DragTriggerUtil';

export { ShowNameState } from './src/main/ets/editmode/data/ShowNameState';

export { default as AppBubbleParams } from './src/main/ets/buildernode/AppBubbleParams';

export { default as AppBubbleCommonParams } from './src/main/ets/buildernode/AppBubbleCommonParams';

export { DeskTopItemStyle } from './src/main/ets/viewmodel/DeskTopItemStyle';

export { PageDesktopOneShotManager } from './src/main/ets/viewmodel/PageDesktopOneShotManager';

export { SwiperPageManager } from './src/main/ets/viewmodel/SwiperPageManager';

export { DragHandlerType, DragProxyManager } from './src/main/ets/viewmodel/DragProxyManager';

export { IDesktopDragHandler } from './src/main/ets/viewmodel/IDesktopDragHandler';

export { IDockDragHandler } from './src/main/ets/viewmodel/IDockDragHandler';

export { PageDesktopViewModelProxy } from './src/main/ets/pagedesktop/viewmodel/PageDesktopViewModelProxy';

export { IPageDesktopViewModel } from './src/main/ets/pagedesktop/viewmodel/IPageDesktopViewModel';

export { OuterPageDesktopViewModelProxy } from './src/main/ets/pagedesktop/viewmodel/OuterPageDesktopViewModelProxy';

export { IOuterPageDesktopViewModel } from './src/main/ets/pagedesktop/viewmodel/IOuterPageDesktopViewModel';

export { MultiSelectCheckboxView } from './src/main/ets/editmode/view/MultiSelectCheckboxView';

export {
  OpenFolderAppBubbleLayout,
  openFolderAppBubbleLayout,
} from './src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';

export {
  OpenFolderHiddenIconLayout,
  openFolderHiddenIconLayout,
} from './src/main/ets/folder/viewmdoel/OpenFolderHiddenIconLayout';

export { BigFolderComponentLayout } from './src/main/ets/folder/viewmdoel/BigFolderComponentLayout';

export { multiSelectAnimateManager, MultiSelectAnimateManager } from './src/main/ets/editmode/model/MultiSelectAnimateManager';

export { MultiSelectAnimationView } from './src/main/ets/editmode/view/MultiSelectAnimationView';

export { FormStackItemBuildInterface, FormStackItemViewType } from './src/main/ets/formstack/FormStackItemBuildInterface';

export { FormStackItemBuildParam } from './src/main/ets/formstack/FormStackItemBuildParam';

export { FormStackItemViewData } from './src/main/ets/formstack/FormStackItemViewData';

export { formStackItemViewManager } from './src/main/ets/formstack/FormStackItemViewManager';

export { FormBuildItem } from './src/main/ets/uicomponents/FormBuildItem';

export { CardNodeControllerManager } from './src/main/ets/manager/CardNodeControllerManager';

export { default as HoverAnimationUtil } from './src/main/ets/utils/HoverAnimationUtil';

export { AppIconCommonView } from './src/main/ets/launchericon/view/AppIconCommonView';

export {
  AppIconLongPressGestureEventIface
} from './src/main/ets/launchericon/interface/AppIconLongPressGestureEventIface';

export { AppIconGestureJudgeIface } from './src/main/ets/launchericon/interface/AppIconGestureJudgeIface';

export { AppIconDragEventIface } from './src/main/ets/launchericon/interface/AppIconDragEventIface';

export { AppIconConfig } from './src/main/ets/launchericon/config/AppIconConfig';

export { AppIconDefaultModifier } from './src/main/ets/launchericon/interface/AppIconDefaultModifier';

export { AppIconContainerModifier } from './src/main/ets/launchericon/interface/AppIconContainerModifier';

export { AppIconCommonEvent } from './src/main/ets/launchericon/viewmodel/AppIconCommonEvent';

export { MenuCommonUtil } from './src/main/ets/utils/MenuCommonUtil';

export { UninstallDialogUtil } from './src/main/ets/utils/UninstallDialogUtil';

export { DesktopSettingUtils } from './src/main/ets/utils/DesktopSettingUtil';

export { GridPositionFindUtil, ItemLocation } from './src/main/ets/utils/GridPositionFindUtil'

export {
  pageEditManager,
  PageEditState,
  EditModeBlankAnimatePageData,
  EditModeDragAnimatePageData,
  EditModeDragPageTipTextData,
  EditModeDragPageData,
  EditModeEditPageData,
} from './src/main/ets/editmode/model/PageEditManager';

export { PageDragManager } from './src/main/ets/editmode/model/PageDragManager';

export { PageEditViewModel, PageEditItemViewData } from './src/main/ets/editmode/viewModel/PageEditViewModel';

export {
  batchUninstallChain,
  UninstallMode,
  ForwardType,
} from './src/main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';

export { BatchItemInfo, RemoveDialogConfig, IconImage } from './src/main/ets/editmode/viewModel/batchUninstall/DialogBatchUninstaller';

export { PageEditAnimationManager, PageEditAnimateHook } from './src/main/ets/editmode/model/PageEditAnimationManager';

export { FocusUtil } from './src/main/ets/utils/FocusUtil';

export { EditModePageActionEnum } from './src/main/ets/editmode/data/PageEditData';

export { launcherVisualEffectMgr } from './src/main/ets/manager/LauncherVisualEffectManager';

export { DesktopSettingsPerefrence } from './src/main/ets/desktopsettings/DesktopSettingsPerefrence';

export { DisplayCountViewModel } from './src/main/ets/displaycount/DisplayCountViewModel';

export { DisplayCountData } from './src/main/ets/displaycount/DisplayCountData';

export { DockItemInfo } from './src/main/ets/bean/DockItemInfo';

export { ContractedFolder } from './src/main/ets/folder/next/contractedfolder/view/ContractedFolder';

export { FolderCommonUtil } from './src/main/ets/folder/next/common/FolderCommonUtil';

export { FolderStyleManager } from './src/main/ets/folder/next/common/FolderStyleManager';

export { ContractedFolderCommonViewModel } from './src/main/ets/folder/next/common/viewmodel/ContractedFolderCommonViewModel';

export { ContractedFolderImageObserver
} from './src/main/ets/folder/next/contractedfolder/viewmodel/layout/ContractedFolderImageObserver';


export {
  FolderResizeUtil
} from './src/main/ets/folder/next/contractedfolder/viewmodel/layout/resize/FolderResizeUtil';

export {
  folderIconDataMgr
} from './src/main/ets/folder/next/contractedfolder/viewmodel/manager/ContractedFolderIconDataManager';
export { FolderIconConfigUtil } from './src/main/ets/folder/model/FolderIconConfigUtil';
export { AppIconData } from './src/main/ets/launchericon/viewmodel/AppIconData';
export { AppNameVm } from './src/main/ets/launchericon/viewmodel/AppNameVm';
export { FoldExpandAnimUtils } from './src/main/ets/utils/FoldExpandAnimUtils';

export { FoldAnimationConstants } from './src/main/ets/constants/FoldAnimationConstants';

export { UltraScreenExpandAnimUtils } from './src/main/ets/utils/UltraScreenExpandAnimUtils';

export { FolderSnapshotManager, FolderSnapInfo } from './src/main/ets/folder/next/common/manager/FolderSnapshotManager';

export { FormStackConfig } from './src/main/ets/formstack/FormStackConfig';

export type { FormStackItemEventCb } from './src/main/ets/formstack/FormStackItemEventCb';

export { rdbTaskPool } from './src/main/ets/db/RdbTaskPool';

export { FormDFXUtil } from './src/main/ets/utils/FormDFXUtil';

export { DesktopIconShowNameManager } from './src/main/ets/manager/DesktopIconShowNameManager';

export { UecPreloadCommonUtil } from './src/main/ets/utils/UecPreloadCommonUtil';