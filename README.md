<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Terraform Implementation - README</title>
  <style>
    :root{
      --bg:#0f1724;
      --card:#0b1220;
      --muted:#9aa4b2;
      --accent:#60a5fa;
      --accent-2:#7c3aed;
      --text:#e6eef6;
      --glass: rgba(255,255,255,0.03);
      --card-pad:20px;
      --maxw:1000px;
      --mono: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", "Courier New", monospace;
      --sans: Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
    }

    html,body{
      height:100%;
      margin:0;
      background: linear-gradient(180deg, #061026 0%, #07111b 50%, #071428 100%);
      color:var(--text);
      font-family:var(--sans);
      -webkit-font-smoothing:antialiased;
      -moz-osx-font-smoothing:grayscale;
      line-height:1.5;
    }

    .container{
      max-width:var(--maxw);
      margin:36px auto;
      padding:24px;
    }

    header{
      display:flex;
      align-items:center;
      gap:18px;
      margin-bottom:18px;
    }

    .logo{
      width:72px;
      height:72px;
      border-radius:12px;
      background: linear-gradient(135deg,var(--accent),var(--accent-2));
      display:flex;
      align-items:center;
      justify-content:center;
      font-weight:700;
      color:#04263b;
      box-shadow: 0 8px 30px rgba(12,34,64,0.6), inset 0 -6px 18px rgba(255,255,255,0.03);
      font-family:var(--mono);
      font-size:20px;
    }

    h1{
      margin:0;
      font-size:28px;
      letter-spacing:0.2px;
    }

    .subtitle{
      color:var(--muted);
      margin-top:6px;
      font-size:13px;
    }

    .card{
      background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
      border-radius:12px;
      padding:var(--card-pad);
      box-shadow: 0 6px 24px rgba(2,6,23,0.6);
      margin-top:14px;
      overflow:auto;
      border: 1px solid rgba(255,255,255,0.03);
    }

    section + section{
      margin-top:18px;
    }

    h2{
      margin:4px 0 12px 0;
      font-size:18px;
      color:var(--text);
      display:flex;
      align-items:center;
      gap:10px;
    }

    h3{
      margin:10px 0 8px 0;
      font-size:15px;
      color:var(--accent);
    }

    p, li{
      color:var(--text);
      font-size:14px;
      margin:6px 0;
    }

    ul{
      margin:8px 0 12px 20px;
    }

    .muted{
      color:var(--muted);
      font-size:13px;
    }

    .grid{
      display:grid;
      grid-template-columns: 1fr;
      gap:12px;
    }

    @media(min-width:880px){
      .grid{ grid-template-columns: 1fr 1fr; }
    }

    .code{
      background: rgba(0,0,0,0.35);
      padding:10px 12px;
      border-radius:8px;
      font-family:var(--mono);
      font-size:13px;
      color:#cfe8ff;
      overflow:auto;
      border:1px solid rgba(255,255,255,0.02);
    }

    .section-title{
      display:flex;
      align-items:center;
      gap:10px;
      margin-bottom:8px;
    }

    .note{
      background: linear-gradient(90deg, rgba(124,58,237,0.06), rgba(96,165,250,0.04));
      padding:10px;
      border-radius:8px;
      border:1px solid rgba(255,255,255,0.02);
      color:var(--muted);
      font-size:13px;
    }

    footer{
      margin-top:20px;
      color:var(--muted);
      font-size:13px;
      text-align:center;
    }

    /* fancier list bullets */
    li::marker{
      color:var(--accent);
      font-weight:700;
    }

    .two-col{
      display:grid;
      gap:12px;
      grid-template-columns: 1fr;
    }

    @media(min-width:1100px){
      .two-col{ grid-template-columns: 1fr 1fr; }
    }

    .large{
      font-size:16px;
      color:var(--accent-2);
      margin-top:0;
      margin-bottom:6px;
    }

  </style>
</head>
<body>
  <div class="container">
    <header>
      <div class="logo">TF</div>
      <div>
        <h1>Terraform Implementation</h1>
        <div class="subtitle">Project README generated from your documentation</div>
      </div>
    </header>

    <div class="card">
      <section id="high-level">
        <div class="section-title">
          <h2>High-level architecture</h2>
        </div>

        <ul>
          <li><strong>Networking</strong> – A single VPC with 3 public and 3 private subnets across three AZs.</li>
          <li><strong>Internet</strong> – Internet Gateway + NAT Gateway so private subnets can reach the internet.</li>
          <li><strong>Routing</strong> – Route tables for public and private subnets.</li>
          <li><strong>Security</strong> – Multiple Security Groups (web, app, db, ALBs, bastion) and ingress/egress rules connecting tiers.</li>
          <li><strong>Compute</strong> – Bastion host (public) to access private instances.</li>
          <li><strong>Webtier</strong> – A single “golden” web instance and an Auto Scaling Group (ASG) that uses an AMI baked from that instance.</li>
          <li><strong>Apptier</strong> – A single “golden” app instance and an ASG baked similarly.</li>
          <li><strong>DBtier</strong> – A private EC2 running MySQL, provisioned via remote-exec (through bastion).</li>
          <li><strong>Loadbalancing</strong> – Public ALB in front of the web tier.</li>
          <li><strong>Internallb</strong> – Internal ALB in front of the app tier.</li>
          <li><strong>Baking</strong> – ASG modules use <code>aws_ami_from_instance</code> to create an AMI from the single instance created in the corresponding module, then the ASG launches instances from that AMI.</li>
          <li><strong>Root</strong> – The root <code>main.tf</code> wires the modules together and passes outputs/IDs from one module to the next to establish dependencies and values.</li>
        </ul>
      </section>

      <section id="project-wiring" style="margin-top:14px;">
        <h2>Project wiring (how modules are used in root)</h2>
        <ul>
          <li><strong>VPC</strong> – module "vpc" -> creates network and outputs <code>vpcid</code>, <code>pubsub</code>, <code>prisub</code>.</li>
          <li><strong>SG</strong> – module "sg" -> creates security groups, consumes <code>vpcid</code>, outputs <code>sgs</code>.</li>
          <li><strong>Bastion</strong> – module "bast" -> consumes public subnets + SGs; outputs <code>chatbastpubip</code>.</li>
          <li><strong>DB</strong> – module "db" -> consumes private subnets, SGs, AMI, bastion IP.</li>
          <li><strong>App</strong> – module "app" -> consumes private subnets, SGs, AMI, bastion IP; outputs <code>chatappid</code>.</li>
          <li><strong>Web</strong> – module "web" -> consumes public subnets, SGs, AMI, bastion IP; outputs <code>chatwebid</code>.</li>
          <li><strong>Internalalb</strong> – module "intalb" -> consumes VPC ID, app instance ID, SGs, private subnets.</li>
          <li><strong>Publicalb</strong> – module "pubalb" -> consumes VPC ID, web instance ID, SGs, public subnets.</li>
          <li><strong>Appasg</strong> – consumes <code>chatappid</code> to create AMI and ASG.</li>
          <li><strong>Webasg</strong> – consumes <code>chatwebid</code> to create AMI and ASG.</li>
        </ul>

        <p class="muted large">This enforces the order: <strong>VPC → SG → Bastion → DB/App/Web → ALBs → ASGs</strong></p>
      </section>

      <section id="modules" style="margin-top:18px;">
        <h2>Module-by-module detailed documentation</h2>

        <article id="vpc_module" style="margin-top:10px;">
          <h3>module: vpc_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Create the VPC, NAT, public/private subnets across 3 AZs, and routing.</li>
            <li><strong>Resources</strong> – aws_vpc, aws_subnet, aws_igw, aws_nat_gateway, aws_route_table, aws_route_table_association.</li>
            <li><strong>Inputs</strong> – <code>aza</code>, <code>azb</code>, <code>azc</code>.</li>
            <li><strong>Outputs</strong> – <code>vpcid</code>, <code>pubsub</code>, <code>prisub</code>.</li>
            <li><strong>Interactions</strong> – Other modules consume these outputs.</li>
            <li><strong>Notable</strong> – CIDR is hardcoded, NAT only in AZ A, route tables correct, AZs parameterized.</li>
            <li><strong>Recommendations</strong> – Make CIDR configurable, multi-AZ NAT optional.</li>
          </ul>
        </article>

        <article id="security_group_module" style="margin-top:10px;">
          <h3>module: security_group_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Create security groups for web, app, db, ALBs, bastion.</li>
            <li><strong>Resources</strong> – aws_security_group, ingress rules, egress rules.</li>
            <li><strong>Inputs</strong> – <code>vpcid</code>.</li>
            <li><strong>Outputs</strong> – <code>sgs</code> map (app, web, db, bast, albapp, albweb).</li>
            <li><strong>Interactions</strong> – Passed to app, web, db, and ALB modules.</li>
            <li><strong>Notable</strong> – Several ports open to <code>0.0.0.0/0</code>, SG-to-SG rules well designed.</li>
            <li><strong>Recommendations</strong> – Restrict SSH, add more descriptive tags.</li>
          </ul>
        </article>

        <article id="basthost_module" style="margin-top:10px;">
          <h3>module: basthost_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Create a bastion host for SSH into private instances.</li>
            <li><strong>Resources</strong> – aws_instance, provisioners (copy key + chmod on remote).</li>
            <li><strong>Inputs</strong> – public subnets, SGs, AMI, key path, key name.</li>
            <li><strong>Outputs</strong> – <code>chatbastpubip</code>.</li>
            <li><strong>Interactions</strong> – Used by DB, app, web for provisioning.</li>
            <li><strong>Notable</strong> – Copies private key to bastion (security risk).</li>
            <li><strong>Risks</strong> – Storing private key, SSH open to world.</li>
            <li><strong>Recommendations</strong> – Use SSM Session Manager, restrict SSH, remove key copy.</li>
          </ul>
        </article>

        <article id="database_module" style="margin-top:10px;">
          <h3>module: database_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Launch DB EC2 and configure MySQL using remote-exec.</li>
            <li><strong>Resources</strong> – aws_instance, remote-exec for installation and configuration.</li>
            <li><strong>Inputs</strong> – AMI, instance type, private subnets, SGs, bastion IP, private key path.</li>
            <li><strong>Outputs</strong> – <code>chatdbpriip</code>.</li>
            <li><strong>Interactions</strong> – Receives app SG traffic, provisioning via bastion.</li>
            <li><strong>Notable</strong> – MySQL install via provisioner, bind-address 0.0.0.0.</li>
            <li><strong>Risks</strong> – Provisioners fragile, idempotency issues.</li>
            <li><strong>Recommendations</strong> – Use user-data, AMI baking, or RDS; parameterize DB credentials.</li>
          </ul>
        </article>

        <article id="app_module" style="margin-top:10px;">
          <h3>module: app_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Create single “golden” app instance used to bake AMI.</li>
            <li><strong>Resources</strong> – aws_instance, null_resource trigger.</li>
            <li><strong>Inputs</strong> – AMI, instance type, key name, key path, SGs, private subnets, bastion IP.</li>
            <li><strong>Outputs</strong> – <code>chatappid</code>.</li>
            <li><strong>Interactions</strong> – Used by app_asg_module.</li>
            <li><strong>Notable</strong> – Provisioners commented out; image may be incomplete.</li>
            <li><strong>Risks</strong> – AMI may capture partial state.</li>
            <li><strong>Recommendations</strong> – Use Packer, user-data, proper image lifecycle.</li>
          </ul>
        </article>

        <article id="app_alb_module" style="margin-top:10px;">
          <h3>module: app_alb_module (internal ALB)</h3>
          <ul>
            <li><strong>Purpose</strong> – Internal ALB for app tier.</li>
            <li><strong>Resources</strong> – aws_lb, aws_lb_target_group, listener, attachment.</li>
            <li><strong>Inputs</strong> – VPC ID, app instance ID, SGs, private subnets, port/protocol.</li>
            <li><strong>Interactions</strong> – ALB SG uses albapp; app SG allows port 8001.</li>
            <li><strong>Notable</strong> – Routes internal traffic only.</li>
          </ul>
        </article>

        <article id="web_alb_module" style="margin-top:10px;">
          <h3>module: web_alb_module (public ALB)</h3>
          <ul>
            <li><strong>Purpose</strong> – Internet-facing ALB for web tier.</li>
            <li><strong>Resources</strong> – aws_lb, target group, listener, attachment.</li>
            <li><strong>Inputs</strong> – VPC ID, web instance ID, SGs, public subnets, port/protocol.</li>
            <li><strong>Interactions</strong> – SG allows <code>0.0.0.0/0</code> on port 80.</li>
            <li><strong>Notable</strong> – Public ALB + public web instance (common demo pattern).</li>
          </ul>
        </article>

        <article id="app_asg_module" style="margin-top:10px;">
          <h3>module: app_asg_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Bake AMI and create ASG for app tier.</li>
            <li><strong>Resources</strong> – aws_ami_from_instance, launch template, ASG.</li>
            <li><strong>Inputs</strong> – instance ID, instance type, key name, SGs, private subnets, scaling settings.</li>
            <li><strong>Notable</strong> – AMIs created on apply; may produce many AMIs.</li>
            <li><strong>Risks</strong> – AMI sprawl, dependency on instance existence.</li>
            <li><strong>Recommendations</strong> – Use Packer, add AMI lifecycle.</li>
          </ul>
        </article>

        <article id="web_asg_module" style="margin-top:10px;">
          <h3>module: web_asg_module</h3>
          <ul>
            <li><strong>Purpose</strong> – Same as app ASG but for web tier.</li>
            <li><strong>Inputs</strong> – instance ID, SGs, public subnets, instance settings.</li>
            <li><strong>Notes</strong> – Same risks and improvements as app ASG.</li>
          </ul>
        </article>

      </section>

      <section id="cross-cutting" style="margin-top:18px;">
        <h2>Cross-cutting notes, gotchas, and risks</h2>
        <ul>
          <li><strong>Provisioners</strong> – Fragile, prefer user-data or baked images.</li>
          <li><strong>Imagebaking</strong> – Use of <code>aws_ami_from_instance</code> is demo-friendly but not CI-friendly.</li>
          <li><strong>Security</strong> – SSH open to world, private key copied to bastion.</li>
          <li><strong>Hardcoded</strong> – CIDR, AMI, AZs, key paths.</li>
          <li><strong>NAT</strong> – Single NAT only.</li>
          <li><strong>Tagging</strong> – Could be more consistent.</li>
          <li><strong>Outputs</strong> – Root outputs empty.</li>
          <li><strong>Lifecycle</strong> – AMI creation may break if instance replaced.</li>
        </ul>
      </section>

      <section id="improvements" style="margin-top:18px;">
        <h2>Suggested small improvements</h2>
        <ul>
          <li><strong>Addoutputs</strong> – Bastion IP, ALB DNS, ASG names.</li>
          <li><strong>Parameterize</strong> – CIDR, NAT, AMI.</li>
          <li><strong>Replace</strong> – Provisioners with user-data or Packer.</li>
          <li><strong>Removekey</strong> – Don’t store private key on bastion.</li>
          <li><strong>Tags</strong> – Add environment, owner, cost tags.</li>
          <li><strong>IAM</strong> – Ensure required permissions.</li>
          <li><strong>Keys</strong> – Make key path optional.</li>
        </ul>
      </section>

      <footer>
        <p class="muted">This README was generated from your supplied Terraform documentation content without altering the original wording. Copy this HTML into <code>README.html</code> or embed into a documentation site.</p>
      </footer>
    </div>
  </div>
</body>
</html>
