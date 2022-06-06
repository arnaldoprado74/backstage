import React from 'react';
import { Navigate, Route } from 'react-router';
import { apis } from './apis';
import AlarmIcon from '@material-ui/icons/Alarm';

// @Backstage
import { gitlabAuthApiRef, githubAuthApiRef } from '@backstage/core-plugin-api';
import {
  RELATION_API_CONSUMED_BY,
  RELATION_API_PROVIDED_BY,
  RELATION_CONSUMES_API,
  RELATION_DEPENDENCY_OF,
  RELATION_DEPENDS_ON,
  RELATION_HAS_PART,
  RELATION_OWNED_BY,
  RELATION_OWNER_OF,
  RELATION_PART_OF,
  RELATION_PROVIDES_API,
} from '@backstage/catalog-model';

// Plugins
import { ApacheAirflowPage } from '@backstage/plugin-apache-airflow';
import { apiDocsPlugin, ApiExplorerPage } from '@backstage/plugin-api-docs';
import { AzurePullRequestsPage } from '@backstage/plugin-azure-devops';
import {
  CatalogEntityPage,
  CatalogIndexPage,
  catalogPlugin,
} from '@backstage/plugin-catalog';
import {
  CatalogImportPage,
  catalogImportPlugin,
} from '@backstage/plugin-catalog-import';
import {
  CostInsightsLabelDataflowInstructionsPage,
  CostInsightsPage,
  CostInsightsProjectGrowthInstructionsPage,
} from '@backstage/plugin-cost-insights';
import { ExplorePage } from '@backstage/plugin-explore';
import { GraphiQLPage } from '@backstage/plugin-graphiql';
import { HomepageCompositionRoot } from '@backstage/plugin-home';
import { LighthousePage } from '@backstage/plugin-lighthouse';
import { orgPlugin } from '@backstage/plugin-org';
import { NewRelicPage } from '@backstage/plugin-newrelic';
import { ReportIssue, TextSize } from '@backstage/plugin-techdocs-module-addons-contrib';
import { ScaffolderPage, scaffolderPlugin } from '@backstage/plugin-scaffolder';
import { orgPlugin } from '@backstage/plugin-org';
import { SearchPage } from '@backstage/plugin-search';
import { TechRadarPage } from '@backstage/plugin-tech-radar';
import { TechDocsAddons } from '@backstage/plugin-techdocs-react';

import {
  TechDocsIndexPage,
  techdocsPlugin,
  TechDocsReaderPage,
} from '@backstage/plugin-techdocs';
import { TechDocsAddons } from '@backstage/plugin-techdocs-react';
import { TechRadarPage } from '@backstage/plugin-tech-radar';
import { ReportIssue } from '@backstage/plugin-techdocs-module-addons-contrib';
import {
  UserSettingsPage,
  UserSettingsTab,
} from '@backstage/plugin-user-settings';
import { apis } from './apis';

// Components
import { AdvancedSettings } from './components/advancedSettings';
import { entityPage } from './components/catalog/EntityPage';
import { homePage } from './components/home/HomePage';
import { searchPage } from './components/search/SearchPage';
import { Root } from './components/Root';
import { techDocsPage } from './components/techdocs/TechDocsPage';
import { SignInPage, AlertDisplay, OAuthRequestDialog } from '@backstage/core-components';
import { createApp } from '@backstage/app-defaults';
import { FlatRoutes } from '@backstage/core-app-api';
import { CatalogGraphPage } from '@backstage/plugin-catalog-graph';
import { PermissionedRoute } from '@backstage/plugin-permission-react';
import { catalogEntityCreatePermission } from '@backstage/plugin-catalog-common/alpha';

const app = createApp({
  apis,
  //plugins: Object.values(plugins),
  icons: {
    // Custom icon example
    alert: AlarmIcon,
  },
  components: {
    SignInPage: props => {
      return (
        <SignInPage
          {...props}
          providers={[{
            id: 'gitlab-auth-provider',
            title: 'GitLab',
            message: 'Sign in using GitLab',
            apiRef: gitlabAuthApiRef,
            }, {
            id: 'github-auth-provider',
            title: 'GitHub',
            message: 'Sign in using GitHub',
            apiRef: githubAuthApiRef,
            }]}
          title="Select a sign-in method"
          align="center"
        />
      );
    },
  },
  bindRoutes({ bind }) {
    bind(catalogPlugin.externalRoutes, {
      createComponent: scaffolderPlugin.routes.root,
      viewTechDoc: techdocsPlugin.routes.docRoot,
    });
    bind(apiDocsPlugin.externalRoutes, {
      registerApi: catalogImportPlugin.routes.importPage,
    });
    bind(scaffolderPlugin.externalRoutes, {
      registerComponent: catalogImportPlugin.routes.importPage,
    });
    bind(orgPlugin.externalRoutes, {
      catalogIndex: catalogPlugin.routes.catalogIndex,
    });
  },
});

const AppProvider = app.getProvider();
const AppRouter = app.getRouter();

const routes = (
  <FlatRoutes>
    <Navigate key="/" to="catalog" />
    {/* TODO(rubenl): Move this to / once its more mature and components exist */}
    <Route path="/home" element={<HomepageCompositionRoot />}>
      {homePage}
    </Route>
    <Route path="/catalog" element={<CatalogIndexPage />} />
    <Route
      path="/catalog/:namespace/:kind/:name"
      element={<CatalogEntityPage />}
    >
      {entityPage}
    </Route>
    <PermissionedRoute
      path="/catalog-import"
      permission={catalogEntityCreatePermission}
      element={<CatalogImportPage />}
    />
    <Route
      path="/catalog-graph"
      element={
        <CatalogGraphPage
          initialState={{
            selectedKinds: ['component', 'domain', 'system', 'api', 'group'],
            selectedRelations: [
              RELATION_OWNER_OF,
              RELATION_OWNED_BY,
              RELATION_CONSUMES_API,
              RELATION_API_CONSUMED_BY,
              RELATION_PROVIDES_API,
              RELATION_API_PROVIDED_BY,
              RELATION_HAS_PART,
              RELATION_PART_OF,
              RELATION_DEPENDS_ON,
              RELATION_DEPENDENCY_OF,
            ],
          }}
        />
      }
    />
    <Route path="/docs" element={<TechDocsIndexPage />} />
    <Route
      path="/docs/:namespace/:kind/:name/*"
      element={<TechDocsReaderPage />}
    >
      {techDocsPage}
      <TechDocsAddons>
        <ReportIssue />
        <TextSize />
      </TechDocsAddons>
    </Route>
    <Route path="/create" element={<ScaffolderPage />} />
    <Route path="/api-docs" element={<ApiExplorerPage />} />
    <Route path="/explore" element={<ExplorePage />} />
    <Route
      path="/tech-radar"
      element={<TechRadarPage width={1500} height={800} />}
    />
    <PermissionedRoute
      path="/catalog-import"
      permission={catalogEntityCreatePermission}
      element={<CatalogImportPage />}
    />
    <Route path="/graphiql" element={<GraphiQLPage />} />
    <Route path="/lighthouse" element={<LighthousePage />} />
    <Route path="/api-docs" element={<ApiExplorerPage />} />
    <Route path="/newrelic" element={<NewRelicPage />} />
    <Route path="/search" element={<SearchPage />}>
      {searchPage}
    </Route>
    <Route path="/catalog-graph" element={<CatalogGraphPage />} />
    <Route path="/cost-insights" element={<CostInsightsPage />} />
    <Route
      path="/cost-insights/investigating-growth"
      element={<CostInsightsProjectGrowthInstructionsPage />}
    />
    <Route
      path="/cost-insights/labeling-jobs"
      element={<CostInsightsLabelDataflowInstructionsPage />}
    />
    /*Route path="/settings" element={<UserSettingsPage />}*/
    <Route path="/azure-pull-requests" element={<AzurePullRequestsPage />} />
    <Route path="/settings" element={<UserSettingsPage />}>
      <UserSettingsTab path="/advanced" title="Advanced">
        <AdvancedSettings />
      </UserSettingsTab>
    </Route>
    <Route path="/apache-airflow" element={<ApacheAirflowPage />} />
  </FlatRoutes>
);

const App = () => (
  <AppProvider>
    <AlertDisplay />
    <OAuthRequestDialog />
    <AppRouter>
      <Root>{routes}</Root>
    </AppRouter>
  </AppProvider>
);

export default App;
